class JobsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :authenticate_user!, except: [:show]
  # before_action :authenticate_user!, only: [:new, :create]

  def index
    @jobs = Job.active
    @jobs = @jobs.search(params[:search]) if params[:search]
    @jobs = @jobs.order(sort_column + " " + sort_direction)
  end

  def show
    @job = Job.find params[:id]
  end

  def new
    @now = Time.now
    @job = Job.new(
      start_date: Time.now,
      end_date:   Time.now + 1.week
    )
  end

  def create
    # This does not set user_id to correspond to current user
    #   @job = Job.new create_params
    # This sets user_id for the newly created job
    @job = current_user.jobs.new create_params
    if @job.save
      # Saved the record, now show it?
      # By redirecting to the show action
      redirect_to @job, notice: "Your listing was created"
    else
      # Validation errors, redisplay form
      render :new # this just says to display the `new` view

      # This _would_ end up calling the new action, but that
      #   isn't what we want (no create data that way)
      # redirect_to new_job_path
    end
  end

  def edit
    # @job = Job.find params[:id]
    # raise "NOPE" if @job.user != current_user

    # only find jobs for current_user
    @job = current_user.jobs.find params[:id]
  end

  def update
    @job = current_user.jobs.find params[:id]
    # update sets all the attributes from this hash
    # and then calls save (so returns true iff the
    # object saved without validation errors)
    #   @job.title = params[:job][:title]
    #   @job.description = params[:job][:description]
    #   ...
    #   @job.save
    if @job.update update_params
      # Job was updated with new params
      redirect_to @job, notice: "Your notice was updated"
    else
      # Validation errors, redisplay
      render :edit
    end
  end

  def create_params
    params.require(:job).permit(:title, :description, :start_date, :end_date, :salary, :location, :company, :jobtype)
  end

  def update_params
    # For now, reuse
    create_params
  end

  private

  def sort_column
    Job.column_names.include?(params[:sort]) ? params[:sort] : "end_date"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end

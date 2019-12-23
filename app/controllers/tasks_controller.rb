class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit]
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "タスクを登録しました"
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash[:danger] = "タスクの登録に失敗しました"
      render "toppages/index"
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = "タスクを編集しました"
      redirect_to root_url
    else
      flash[:danger] = "タスクの編集に失敗しました"
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = "タスクを削除しました"
    redirect_back(fallback_location: root_path)
  end
  
  def task_params
    params.require(:task).permit(:status, :content)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end

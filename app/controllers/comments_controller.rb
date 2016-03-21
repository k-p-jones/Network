class CommentsController < ApplicationController
    
    def create
        @thought = Thought.find_by_id(params[:thought_id])
        @comment = @thought.comments.create(params[:comment].permit(:content))
        @comment.user_id = current_user.id
        respond_to do |format|
            format.html {
                 if @comment.save
                    flash[:success] = "Comment Posted!"
                 else
                    flash[:warning] = "Uh oh! Error!"
                 end
                redirect_to thought_path(@thought)
                }
            format.js { @comment.save }    
        end
    end
    
    def destroy
        @thought = Thought.find_by_id(params[:thought_id])
        @comment = Comment.find_by_id(params[:id])
        respond_to do |format|
            format.html {
               if @comment.destroy
                flash[:success] = "Comment Destroyed!"
               else
                flash[:warning] = "Uh oh! Error!"
               end
               redirect_to thought_path(@thought) 
              }
            format.js { @comment.destroy }  
        end
    end
end

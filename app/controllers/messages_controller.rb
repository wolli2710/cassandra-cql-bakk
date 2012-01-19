class MessagesController < ApplicationController

  def index
    @messages = Message.get_messages
  end

  def new
    @uid
  end

  def create
    Message.update_message params[:uid], params[:content]
    redirect_to messages_path
  end

  def destroy
    Message.delete_message(params[:mid])
    redirect_to messages_path
  end

  def delete_messages
    Message.delete_messages
    redirect_to messages_path
  end

end

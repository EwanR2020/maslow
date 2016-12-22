require 'gds_api/need_api'
require 'plek'
require 'json'

class NotesController < ApplicationController
  def create
    authorize! :create, Note
    text = params["notes"]["text"]
    need_id = params["need_id"]
    content_id = params["content_id"] || Maslow.need_api.content_id(need_id).body
    author = current_user

    @note = Note.new(
      text: text,
      need_id: need_id,
      content_id: content_id,
      author: author_attributes(author)
    )

    if @note.save
      flash[:notice] = "Note saved"
    else
      flash[:error] = "Note couldn't be saved: #{@note.errors}"
    end
    redirect_to revisions_need_path(need_id)
  end

private
  def author_attributes(author)
    {
      "name" => author.name,
      "email" => author.email,
      "uid" => author.uid
    }
  end
end

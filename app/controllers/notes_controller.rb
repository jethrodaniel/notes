class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]

  def index
    query = params[:q]

    @notes = if query.present?
      Note.full_text_search(query)
    else
      Note.order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @note = Note.new(content: "", user: Current.user)

    respond_to do |format|
      if @note.save
        format.html { redirect_to edit_note_path(@note) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to notes_path, notice: t(".success") }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to notes_path, notice: t(".success") }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy!

    respond_to do |format|
      format.html do
        redirect_to notes_path, status: :see_other, notice: t(".success")
      end
    end
  end

  private

  def set_note
    @note = Note.find(params.expect(:id))
  end

  def note_params
    params.expect(note: [:title, :content]).merge(user: Current.user)
  end
end

module ApplicationHelper
  include Pagy::Frontend

  def flash_color type
    case type
    in "notice"
      "bg-green-50 dark:bg-green-950 border border-green-400"
    in "alert"
      "bg-red-50 dark:bg-red-950 border border-red-400"
    end
  end
end

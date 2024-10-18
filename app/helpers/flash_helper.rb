module FlashHelper
  def flash_class(flash_type)
    return 'bg-blue-50 border-blue-400 text-blue-800' if flash_type == 'notice'

    'bg-red-50 border-red-400 text-red-800'
  end
end

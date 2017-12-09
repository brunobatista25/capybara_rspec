require 'fileutils'

# modulo com um metodo para tira fotos
module Helper
  def take_screenshot(file_name, result)
    timer_path = Time.now.strftime('%Y_%m_%d').to_s
    file_path = "results/screenshots/test_#{result}/run_#{timer_path}"
    screenshot = "#{file_path}/#{file_name}.png"
    page.save_screenshot(screenshot)
  end
end

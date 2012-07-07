class ViewController < UIViewController

  def viewDidLoad
    @button = self.view.subviews.first

    @button.hidden = true

  end

end

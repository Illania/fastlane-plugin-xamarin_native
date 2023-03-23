describe Fastlane::Actions::XamarinNativeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The xamarin_native plugin is working!")

      Fastlane::Actions::XamarinNativeAction.run(nil)
    end
  end
end

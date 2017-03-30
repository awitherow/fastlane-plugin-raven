describe Fastlane::Actions::RavenAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The raven plugin is working!")

      Fastlane::Actions::RavenAction.run(nil)
    end
  end
end

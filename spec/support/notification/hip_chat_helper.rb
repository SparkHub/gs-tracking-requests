module HipChatHelper

  def stub_hip_chat
    allow_any_instance_of(TrackerHub::Request::Notification::HipChat).to receive(:send_message) do
      true
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

describe ApplicationCable::Connection do
  subject(:connection) { connect }

  include_context "user"

  let(:warden) { instance_double(Warden::Proxy, user:) }
  let(:env) { { "warden" => warden } }

  before do
    allow_any_instance_of(described_class).to receive(:env).and_return(env) # rubocop:disable RSpec/AnyInstance
    stub_connection env:
  end

  describe "#connect" do
    it "sets the current user and adds tags to the logger" do
      allow(connection).to receive(:logger).and_return(double(add_tags: nil)) # rubocop:disable RSpec/SubjectStub, RSpec/VerifiedDoubles

      connection.connect

      expect(connection.current_user).to eq(user)
      expect(connection.logger).to have_received(:add_tags).with("ActionCable", user.email)
    end

    context "when the user is not verified" do
      let(:user) { nil }

      it "rejects the connection" do
        expect { connection.connect }.to raise_error(ActionCable::Connection::Authorization::UnauthorizedError)
      end
    end
  end
end

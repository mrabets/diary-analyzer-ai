# frozen_string_literal: true

# rubocop:disable RSpec/ContextWording, RSpec/BeforeAfterAll
shared_context "user" do
  before(:all) do
    @user = TestProf::AnyFixture.register(:user) do
      create(:user)
    end
  end

  let(:user) { User.find(TestProf::AnyFixture.register(:user).id) }
end
# rubocop:enable RSpec/ContextWording, RSpec/BeforeAfterAll

require "test_helper"

class User::LinkWithGithubTest < ActiveSupport::TestCase
  test "updates user" do
    provider = 'github'
    uid = '111'
    auth = stub(
      provider:,
      uid:,
      info: stub(nickname: "user22")
    )
    user = create :user

    User::SetGithubUsername.expects(:call).with(user, "user22")

    User::LinkWithGithub.(user, auth)

    assert_equal provider, user.provider
    assert_equal uid, user.uid
  end

  test "changes github_username" do
    provider = 'github'
    uid = '111'
    auth = stub(
      provider:,
      uid:,
      info: stub(nickname: "fapdash")
    )
    user = create :user, provider: "github", uid: "111", email: "example@email.com", github_username: "fap-"

    User::LinkWithGithub.(user, auth)

    assert_equal "fapdash", user.github_username
    assert_equal uid, user.uid
    assert_equal provider, user.provider
  end

  test "github_username already associated with account" do
    provider = 'github'
    uid = '111'
    auth = stub(
      provider:,
      uid:,
      info: stub(nickname: "fapdash")
    )
    user = create :user, provider: "github", uid: "111", email: "example@email.com", github_username: "fap-"
    user_2 = create :user, provider: "github", uid: "112", email: "example2@email.com", github_username: "fapdash"

    User::LinkWithGithub.(user, auth)

    assert_equal "fapdash", user.github_username # how? why? should be unique?
    assert_equal "fapdash", user_2.github_username
    assert_equal uid, user.uid
    assert_equal provider, user.provider
  end
end

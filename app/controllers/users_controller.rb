class UsersController < ::BaseController
  def collection
    User.q_search(params)
  end
end

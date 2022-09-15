desc 'Assign lists to a first user!'
task assign_list: :environment do
  user = User.first
  List.update_all(user_id: user.id)
end

class SkillWorker
  include Sidekiq::Worker

  def perform(user_id, answer_id)
    user = User.find(user_id)
    answer = Answer.find(answer_id)
    user.update(skill_level: answer.get_upvotes.size)
  end
end

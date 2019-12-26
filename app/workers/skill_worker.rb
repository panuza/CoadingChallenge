class SkillWorker
  include Sidekiq::Worker

  def perform(user_id, answer_id, vote)
    user = User.find(user_id)
    answer = Answer.find(answer_id)
    if vote == "upvote"
      user.update(skill_level: user.skill_level + 1)
    else
      user.update(skill_level: user.skill_level - 1)
    end
  end
end

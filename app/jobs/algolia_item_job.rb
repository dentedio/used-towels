class AlgoliaItemJob < ApplicationJob
  queue_as :default

  def perform(id, remove)
    item = Item.find(id)
    remove ? item.remove_from_index! : item.index!
  end

end

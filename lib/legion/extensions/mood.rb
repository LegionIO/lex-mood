# frozen_string_literal: true

require 'legion/extensions/mood/version'
require 'legion/extensions/mood/helpers/constants'
require 'legion/extensions/mood/helpers/mood_state'
require 'legion/extensions/mood/runners/mood'
require 'legion/extensions/mood/client'

module Legion
  module Extensions
    module Mood
      extend Legion::Extensions::Core if Legion::Extensions.const_defined?(:Core)
    end
  end
end

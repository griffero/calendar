# frozen_string_literal: true

require "pagy/extras/metadata"
require "pagy/extras/overflow"

Pagy::DEFAULT[:items] = 25
Pagy::DEFAULT[:max_items] = 100
Pagy::DEFAULT[:overflow] = :last_page

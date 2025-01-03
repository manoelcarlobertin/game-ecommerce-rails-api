Devise::Models::Authenticatable::UNSAFE_ATTRIBUTES_FOR_SERIALIZATION =
  Devise::Models::Authenticatable::BLACKLIST_FOR_SERIALIZATION if
    defined?(Devise::Models::Authenticatable::BLACKLIST_FOR_SERIALIZATION)

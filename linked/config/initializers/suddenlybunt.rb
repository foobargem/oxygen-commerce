USE_MIN_WIDTH_CONTAINER = true
USE_BODY_TAG_WITH_BROWSER_CLASS = true
VALIDATION_CONSTRAINTS = {
  :email_format => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i,
  :login_format => /^[a-zA-Z][a-zA-Z0-9_\.]+[a-zA-Z0-9_]$/,
  :login_length_range => 4..30,
  :password_length_range => 4..20,
  :business_number_format => /^(([\d]{13}|[\d]{10})|([\d]{6}-[\d]{7}|[\d]{3}-[\d]{2}-[\d]{5}))$/,
  :url_format => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
  :url_format_without_protocol => /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
}


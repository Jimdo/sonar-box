maintainer       "Jan Brauer"
maintainer_email "jan@jimdo.com"
license          "MIT"
description      "Installs/Configures sonar"
version          "0.1"

%w[apt nginx rvm].each do |cb|
  depends cb
end
supports "ubuntu"

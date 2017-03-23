CREATE DATABASE IF NOT EXISTS `rails_dev`;
CREATE DATABASE IF NOT EXISTS `rails_test`;

CREATE USER 'rails_dev'@'%' IDENTIFIED BY 'rails_dev';
GRANT ALL ON `rails_dev`.* TO 'rails_dev'@'%';

CREATE USER 'rails_test'@'%' IDENTIFIED BY 'rails_test';
GRANT ALL ON `rails_test`.* TO 'rails_test'@'%';

FLUSH PRIVILEGES;

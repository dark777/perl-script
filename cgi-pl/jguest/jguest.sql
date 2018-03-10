CREATE TABLE guestbook (
  id int(5) NOT NULL auto_increment,
  nome varchar(30) NOT NULL default '',
  email varchar(80) default NULL,
  mensagem text NOT NULL,
  ver char(3) default 'off',
  PRIMARY KEY  (id),
  UNIQUE KEY id (id)
) TYPE=MyISAM;
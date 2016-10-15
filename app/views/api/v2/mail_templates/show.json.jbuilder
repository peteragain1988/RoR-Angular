json.mail_template do
  json.id @mail_template.id
  json.name @mail_template.name
  json.subject @mail_template.subject
  json.reply_to @mail_template.reply_to

  json.requires @mail_template.requires
  json.body @mail_template.body

  json.bcc @mail_template.bcc
end
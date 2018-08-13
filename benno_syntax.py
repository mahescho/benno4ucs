from univention.admin.syntax import select


class bennoRole(select):

	choices = [
		('USER', 'Benutzer'),
		('ADMIN', 'Administrator'),
		('REVISOR', 'Revisor'),
	]



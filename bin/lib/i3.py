from json import loads
from subprocess import check_output

class i3:
	def ipc_query(self, type = '', message = ''):
		ans = check_output('i3-msg -t ' + type + ' ' + message, shell = True).decode('utf-8')
		return loads(ans)

	def get_workspaces(self):
		self.workspaces = self.ipc_query('get_workspaces')

	def __init__(self):
		pass

	def get_focused_workspace(self):
		self.get_workspaces()

		for workspace in self.workspaces:
			if (workspace['focused']):
				# return {workspace['name'], workspace['num']}
				return workspace['name']


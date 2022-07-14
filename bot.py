import requests, random, subprocess, os, time

cookies = open('cookies.txt').readlines()
game_id = 417267366

def run_required_apps():
    """
    subprocess.Popen([
        'start',
        'cmd.exe', '@cmd', '/k',
        'required_apps\\remove_heads'
    ])
    """

    os.system('start cmd.exe @cmd /k "required_apps\\multiple_roblox"') 

def get_authorization_ticket(cookie):
    requests_session = requests.session()

    requests_session.cookies['.ROBLOSECURITY'] = cookie
    requests_session.headers['x-csrf-token'] = requests_session.post('https://accountsettings.roblox.com/v1/email').headers['x-csrf-token']
    requests_session.headers['origin'] = 'https://www.roblox.com'
    requests_session.headers['referer'] = 'https://www.roblox.com/'

    authorization_ticket_request = requests_session.post('https://auth.roblox.com/v1/authentication-ticket/')
    authorization_ticket = authorization_ticket_request.headers['rbx-authentication-ticket']

    return authorization_ticket

def join_game(game_id, authorization_ticket):
    browser_tracker = str( random.randint(1111111, 9999999) )

    subprocess.Popen([
        '..\\RobloxPlayerBeta.exe',
        '--play',
        '-a', 'https://www.roblox.com/Login/Negotiate.ashx'
        ' -t', authorization_ticket,
        '-j', f'\'https://assetgame.roblox.com/game/PlaceLauncher.ashx?request=RequestGame&browserTrackerId={browser_tracker}&placeId={game_id}&isPlayTogetherGame=false\'',
        '-b', browser_tracker
    ])

run_required_apps()

time.sleep(5)

for cookie in cookies:
    print(cookie)
    join_game(game_id, get_authorization_ticket(cookie.replace('\n','')))
    time.sleep(5)
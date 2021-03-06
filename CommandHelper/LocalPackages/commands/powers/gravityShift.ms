register_command('gravityshift', 

    array(
    
        'description': 'Power',
        'permission': 'powers.gravityshift',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
            if(has_bind(@sender.'gravityShift')){
                sudo('/gravityshiftstop')
            }
            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('lastUsedGravityShift',5,@sender)){
                return()
            }

            tmsg(@sender,color('RED').'Gravity shift active!')

            sudo('/float up')
            export(@sender.'activeGravityShift',true)
            bind('player_move', array('id': @sender.'gravityShift'), array('player': @sender), @e,@sender){
                @loc = ploc(@sender)
                @radius = 2

                include('/home/minecraft/server/plugins/CommandHelper/includes/isWallNearby.ms')
                @isWallNearby = _isWallNearby(@loc, @radius)
                if(!@isWallNearby){
                    sudo('/gravityshiftstop')
                    tmsg(@sender,color('RED').'Stay close to the walls!')
                }
            }
        }
    )
)
register_command('gravityshiftstop', 

    array(
    
        'description': 'Power',
        'permission': 'powers.gravityshift',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
            @isGravityShiftActive = import(@sender.'activeGravityShift')
            sudo('/float stop')
            export(@sender.'activeGravityShift',false)
            if(@isGravityShiftActive){
                unbind(@sender.'gravityShift')
            }
        }
    )
)

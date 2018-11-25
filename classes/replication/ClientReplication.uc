class ClientReplication extends Engine.Actor config(promod_v2);

var int number;

replication
{
    reliable if (Role == ROLE_Authority)
        number;
}

simulated event PostBeginPlay()
{
    SetTimer(5, true);
}

simulated event PostNetReceive()
{
    super.PostNetReceive();
    log("YES BABY");
}

event Timer()
{
    number++;
}

defaultproperties
{
    number                  =       0

    bNetNotify              =       True
    NetUpdateFrequency      =       1
    bStatic                 =       False
    bNoDelete               =       False
    bAlwaysRelevant         =       True
    netPriority             =       1
}

# cb2025-6-gangwars

### Objects

#### Gang

Type
  - I.E. Yakuza, cyborgs, bikers, clowns, etc

Money
  - integer

Pawns
  - number of street-level gangsters/foot soldiers, can be allocated to parties, strongholds, businesses, or neighborhoods:
  - assigning to a party or stronghold gives direct value/strength to that entity
  - assigning to a business directly impacts that business's defense and performance
  - assigning to a neighborhood provides a (very small) defense to entities within that neighborhood, and increases the gang's "influence" in the neighborhood
  - unassigned pawns are in an assignable pool, I guess they're hanging out at home :)

Power
  - Number
  - Abstract representation of firepower, tech, etc - ability to use violence as a force.
  - Probably a small number to use as a multiplier, i.e. 1.2, for use in calculations involving violence.
  - Example - multiply number of pawns involved in a conflict by power, or something)

Notoriety
  - Number
  - Maybe use for events / goals, or maybe a currency to spend for political power or something
  - Probably increased by events, successful raids/attacks/whatever, passively increased by having influence in neighborhoods

Gangster (list)


#### Gangster

Name
  - I.E. John Pompadour, Grace De La Cruz, Jenny Machete, Raj Yamamoto, Four-Eyes Friedriksen

Gangsters can be assigned to businesses, strongholds, or neighborhoods

Charisma
  - Has a multiplicative effect on business income
  - Reduces chance of pawns fleeing conflict
  - High charisma -> assign to business

Might
  - Has a multiplicative effect when attacking/defending
  - High might -> assign to strongholds or send on attacks
  - Low might -> more likely to die

Honor
  - Affects outcomes of events and questlines that involve them
  - Increases Influence of assigned neighborhoods
  - High honor -> assign to neighborhoods

Can form Party to:
  - Attack other gang's assets
  - Patrol neighborhoods
    - Passive negative impact on other gangs' activities in the neighborhood
    - Can incidentally wound/kill pawns/gangsters assigned to the neighborhood
    - Does NOT increase influence in the neighborhood, as they're not schmoozing but instead hunting
    - Has a chance to spark patrol-specific events or corpolice crackdowns, both of which can have varied effects or cause the party to disband
    - Parties can react easily to goings-on in their current neighborhood (joining fights with opposing parties that are attacking their assets; or scuffling with opposing parties assigned to patrol the same neighborhood)
    - Note that these fights between parties are very dangerous - many pawns are likely to die, as are the associated gangsters. Gangsters are much less likely to die if they defend from a stronghold rather than via a party - but they're also less likely to kill the opposing gangster, more likely to just injure/force disbanding.
    - As such, if you don't have overwhelming numbers, it's better to defend with strongholds than to fight out in the open. If you have big numbers and your enemy attacks your neighborhood, forming a party to sally out and kill them in the streets can be very effective!
    - Gang fight lethality is lower in neighborhoods with high Corpolice Control, so as Corporate Power *collapses*, the gang fight gets deadlier
    - Parties are slow to get to other neighborhoods; so, forming a party in one spot leaves other areas vulnerable if they dont have defense of their own


#### Business

Type
  - I.E. Gambling parlor, Drug store, Lemonade Stand, Construction Company, Harbor, Bar, Handholding spa

Income = (Base income by type) * (Neighborhood influence) * (Conditional modifiers) * (1 + 0.01 * Assigned Pawns) * (1 + Assigned Gangster's Charisma)

#### Stronghold

Represents safehouses, mansions, politcal party offices, bunkers, armories, or anywhere gangsters and pawns can gather in physical (or social) safety, and mobilize sorties for defense of the neighborhood. Assigning gangsters or pawns here provides a blanket increase to defense of:
  - pawns assigned to the neighborhood, who are otherwise vulnerable to enemy Party patrols
  - all businesses within (though not as much as defending them directly)

Gangsters that are assigned to strongholds are much safer, providing their defense to the neighborhood while being hard to kill themselves. Pawns assigned to strongholds can die while defending other neighborhood assets, but gangsters will only die if the stronghold itself is attacked.

#### Neighborhood

Collection of businesses and strongholds.

Corpolice Control
  - Number
  - Represents amount of suppression/control by the Corporate Police in the neighborhood; not sure how this will work yet, likely they can prevent actions from being successful, reduce profits, possibly wrest/remove control, or arrest/kill pawns/gangsters
  - Corpolice Control goes down over time (as the Corporate State starts collapsing into anarchy - maybe events occur as well, like corporate warfare going on in parallel, CEO getting assassinated, environmental catastrophes, or other things). As such, the gang violence gets more, well, violent, until eventually it's all-out bloody warfare and either everyone kills each other off or one gang ascends to dominance.

Influence
  - List of tuples
  - {gangName,number}
  - The higher the influence in a neighborhood, the safer/more profitable the businesses in that neighborhood, esp when they have majority control
  - This means a gang's businesses in a neighborhood it controls are better than owning businesses in others' neighborhoods
  - High influence passively increases Notoriety over time
  - Increased by posting pawns in neighborhood, who hang out at bars and street corners, etc making themselves a nuisance

Assigning pawns or gangsters to neighborhoods allows them to provide a small amount of defense to all businesses, but much less than being assigned to strongholds or directly to businesses. Additionally, they are vulnerable to parties patrolling the neighborhood.

### Game Loop

Game time is composed of logical ticks (can speed up or slow down time by changing how long it takes to tick)
Every X ticks, owned businesses generate income
Every X ticks, pawns and gangsters generate influence
Every X ticks, patrolling parties do (stuff)
After X ticks of attacking a specific location (i.e. not just Patrolling), party resolves attack
Every X ticks, random chance for an event (with a cooldown after an event) (events can follow quest trees?)
Forming a party takes X ticks; Disbanding a party takes Y ticks, where X > Y
Reassigning pawns takes X ticks, reassigning gangsters takes Y ticks, where X > Y (probably)
Moving a party to another location takes X ticks, moving a party to another neighborhood takes Y ticks where Y > X. Maybe use a hex grid within a neighborhood? idk. If we use a hex grid we need to make sure it's not a dominant strategy to just disband a party if you need to move them far away. The game is semi-abstracted, and when a pawn/gangster is not assigned to an organized party, we're not tracking their physical movement in real time - the game takes place over time, not in the span of a few days, is my thinking. (Realistically it takes 30 minutes for one guy to drive across town, but it takes hours to get a group of 15 people together, organized, with a plan, and to not get separated when patrolling around, and oh everyone wait a sec Four-Eyes Friedriksen has to take a leak, etc; there's a reason it takes armies months to campaign but an individual much less time to travel)
Every X ticks, Corpolice have a chance to interfere with activity in each neighborhood correlated to their Control, causing parties to disband, etc

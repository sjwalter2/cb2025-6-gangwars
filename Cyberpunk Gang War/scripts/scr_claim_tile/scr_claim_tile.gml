/// @function scr_claim_tile(tile, owner)
function scr_claim_tile(tile, owner){
tile.gang = owner;
scr_update_gang_spread(tile);
}
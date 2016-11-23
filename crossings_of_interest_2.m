function [crossings] = crossings_of_interest_2(boundaries)

where_the_SWTS_at = strfind(boundaries(7,:),[-1, 2])+1;
where_the_STSW_at = strfind(boundaries(7,:),[2,-1])+1;

SW_to_sheath = boundaries(:,where_the_SWTS_at);
sheath_to_SW = boundaries(:,where_the_STSW_at);

SW_to_sheath(8,:) = 24*60*(datenum(SW_to_sheath(1,:),SW_to_sheath(2,:),SW_to_sheath(3,:),...
    SW_to_sheath(4,:),SW_to_sheath(5,:),SW_to_sheath(6,:)) - datenum(2004,1,1));

sheath_to_SW(8,:) = 24*60*(datenum(sheath_to_SW(1,:),sheath_to_SW(2,:),sheath_to_SW(3,:),...
    sheath_to_SW(4,:),sheath_to_SW(5,:),sheath_to_SW(6,:)) - datenum(2004,1,1));

SWTS_next_begin = 24*60*(datenum(boundaries(1,where_the_SWTS_at+1),boundaries(2,where_the_SWTS_at+1),...
    boundaries(3,where_the_SWTS_at+1),boundaries(4,where_the_SWTS_at+1),...
    boundaries(5,where_the_SWTS_at+1),boundaries(6,where_the_SWTS_at+1)) - datenum(2004,1,1));

STSW_sheath_begin = 24*60*(datenum(boundaries(1,where_the_STSW_at-1),boundaries(2,where_the_STSW_at-1),...
    boundaries(3,where_the_STSW_at-1),boundaries(4,where_the_STSW_at-1),...
    boundaries(5,where_the_STSW_at-1),boundaries(6,where_the_STSW_at-1)) - datenum(2004,1,1));

SW_to_sheath(9,:) = SWTS_next_begin - SW_to_sheath(8,:);
sheath_to_SW(9,:) = sheath_to_SW(8,:) - STSW_sheath_begin;

c = horzcat(SW_to_sheath,sheath_to_SW);
crossings = transpose(sortrows(transpose(c),8));

end
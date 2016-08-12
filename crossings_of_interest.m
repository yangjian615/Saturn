function [crossings] = crossings_of_interest(boundaries,sheath_or_mag)

where_the_MTS_at = strfind(boundaries(7,:),[1 2])+1;
where_the_STM_at = strfind(boundaries(7,:),[2,1])+1;

mag_to_sheath = boundaries(:,where_the_MTS_at);
sheath_to_mag = boundaries(:,where_the_STM_at);

mag_to_sheath(8,:) = 24*60*(datenum(mag_to_sheath(1,:),mag_to_sheath(2,:),mag_to_sheath(3,:),...
    mag_to_sheath(4,:),mag_to_sheath(5,:),mag_to_sheath(6,:)) - datenum(2004,1,1));

sheath_to_mag(8,:) = 24*60*(datenum(sheath_to_mag(1,:),sheath_to_mag(2,:),sheath_to_mag(3,:),...
    sheath_to_mag(4,:),sheath_to_mag(5,:),sheath_to_mag(6,:)) - datenum(2004,1,1));


if sheath_or_mag
    %For magnetosphere%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    MTS_mag_begin = 24*60*(datenum(boundaries(1,where_the_MTS_at-1),boundaries(2,where_the_MTS_at-1),...
        boundaries(3,where_the_MTS_at-1),boundaries(4,where_the_MTS_at-1),...
        boundaries(5,where_the_MTS_at-1),boundaries(6,where_the_MTS_at-1)) - datenum(2004,1,1));

    STM_next_begin = 24*60*(datenum(boundaries(1,where_the_STM_at+1),boundaries(2,where_the_STM_at+1),...
        boundaries(3,where_the_STM_at+1),boundaries(4,where_the_STM_at+1),...
        boundaries(5,where_the_STM_at+1),boundaries(6,where_the_STM_at+1)) - datenum(2004,1,1));

    %amount of time spent in magnetosphere
    mag_to_sheath(9,:) = mag_to_sheath(8,:) - MTS_mag_begin;
    sheath_to_mag(9,:) = STM_next_begin - sheath_to_mag(8,:);

    %ordered_crossings is 2 for MTS
    %"               " is 1 for STM
    c = horzcat(mag_to_sheath,sheath_to_mag);
    %sort by date
    crossings = transpose(sortrows(transpose(c),8));

else
    %For sheath%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    MTS_next_begin = 24*60*(datenum(boundaries(1,where_the_MTS_at+1),boundaries(2,where_the_MTS_at+1),...
        boundaries(3,where_the_MTS_at+1),boundaries(4,where_the_MTS_at+1),...
        boundaries(5,where_the_MTS_at+1),boundaries(6,where_the_MTS_at+1)) - datenum(2004,1,1));

    STM_sheath_begin = 24*60*(datenum(boundaries(1,where_the_STM_at-1),boundaries(2,where_the_STM_at-1),...
        boundaries(3,where_the_STM_at-1),boundaries(4,where_the_STM_at-1),...
        boundaries(5,where_the_STM_at-1),boundaries(6,where_the_STM_at-1)) - datenum(2004,1,1));

    %amount of time spent in sheath
    mag_to_sheath(9,:) = MTS_next_begin - mag_to_sheath(8,:);
    sheath_to_mag(9,:) = sheath_to_mag(8,:) - STM_sheath_begin;

    c = horzcat(mag_to_sheath,sheath_to_mag);
    crossings = transpose(sortrows(transpose(c),8));


end
end
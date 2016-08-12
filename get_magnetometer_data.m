function [magnetometer_data] = get_magnetometer_data(file_number)
    %file names and directories of magnetometer data
      path_Name = {'/media/computation/FantomHD/CassiniMagData/'};
%     file_Name(1,:) = {'2004/mod_3.txt'};

%     2004
    file_Name(1,:) = {'2004/04091_04135_00_FGM_KRTP_1S.TAB'};
    file_Name(2,:) = {'2004/04135_04240_00_FGM_KRTP_1S.TAB'};
    file_Name(3,:) = {'2004/04240_04326_0A_FGM_KRTP_1S.TAB'};
    file_Name(4,:) = {'2004/04326_04366_0B_FGM_KRTP_1S.TAB'};
    file_Name(5,:) = {'2004/04366_05032_0C_FGM_KRTP_1S.TAB'};

%     2005
    file_Name(6,:) = {'2005/05032_05058_03_FGM_KRTP_1S.TAB'};
    file_Name(7,:) = {'2005/05058_05078_04_FGM_KRTP_1S.TAB'};
    file_Name(8,:) = {'2005/05078_05096_05_FGM_KRTP_1S.TAB'};
    file_Name(9,:) = {'2005/05096_05113_06_FGM_KRTP_1S.TAB'};
    file_Name(10,:) = {'2005/05113_05132_07_FGM_KRTP_1S.TAB'};
    file_Name(11,:) = {'2005/05132_05150_08_FGM_KRTP_1S.TAB'};
    file_Name(12,:) = {'2005/05150_05168_09_FGM_KRTP_1S.TAB'};
    file_Name(13,:) = {'2005/05168_05186_10_FGM_KRTP_1S.TAB'}; 
    file_Name(14,:) = {'2005/05186_05205_11_FGM_KRTP_1S.TAB'};
    file_Name(15,:) = {'2005/05205_05223_12_FGM_KRTP_1S.TAB'};
    file_Name(16,:) = {'2005/05223_05240_13_FGM_KRTP_1S.TAB'};
    file_Name(17,:) = {'2005/05240_05257_14_FGM_KRTP_1S.TAB'};
    file_Name(18,:) = {'2005/05257_05275_15_FGM_KRTP_1S.TAB'};
    file_Name(19,:) = {'2005/05275_05293_16_FGM_KRTP_1S.TAB'};
    file_Name(20,:) = {'2005/05293_05317_17_FGM_KRTP_1S.TAB'};
    file_Name(21,:) = {'2005/05317_05345_18_FGM_KRTP_1S.TAB'};
    file_Name(22,:) = {'2005/05345_06005_19_FGM_KRTP_1S.TAB'};
    file_Name(23,:) = {'2005/05345_06005_19_FGM_KRTP_1S.TAB'};
    
%   2006 
    file_Name(24,:) = {'2006/06005_06036_20_FGM_KRTP_1S.TAB'};
    file_Name(25,:) = {'2006/06036_06068_21_FGM_KRTP_1S.TAB'};
    file_Name(26,:) = {'2006/06068_06099_22_FGM_KRTP_1S.TAB'};
    file_Name(27,:) = {'2006/06099_06130_23_FGM_KRTP_1S.TAB'};
    file_Name(28,:) = {'2006/06130_06161_24_FGM_KRTP_1S.TAB'};
    file_Name(29,:) = {'2006/06161_06193_25_FGM_KRTP_1S.TAB'};
    file_Name(30,:) = {'2006/06193_06216_26_FGM_KRTP_1S.TAB'};
    file_Name(31,:) = {'2006/06216_06240_27_FGM_KRTP_1S.TAB'};
    file_Name(32,:) = {'2006/06240_06260_28_FGM_KRTP_1S.TAB'};
    file_Name(33,:) = {'2006/06260_06276_29_FGM_KRTP_1S.TAB'};
    file_Name(34,:) = {'2006/06276_06292_30_FGM_KRTP_1S.TAB'};
    file_Name(35,:) = {'2006/06292_06307_31_FGM_KRTP_1S.TAB'};
    file_Name(36,:) = {'2006/06307_06318_32_FGM_KRTP_1S.TAB'};
    file_Name(37,:) = {'2006/06318_06330_33_FGM_KRTP_1S.TAB'};
    file_Name(38,:) = {'2006/06330_06342_34_FGM_KRTP_1S.TAB'};
    file_Name(39,:) = {'2006/06342_06356_35_FGM_KRTP_1S.TAB'};
    file_Name(40,:) = {'2006/06356_07008_36_FGM_KRTP_1S.TAB'};

%     2007
    file_Name(41,:) = {'2007/07008_07024_37_FGM_KRTP_1S.TAB'};
    file_Name(42,:) = {'2007/07024_07041_38_FGM_KRTP_1S.TAB'};
    file_Name(43,:) = {'2007/07041_07058_39_FGM_KRTP_1S.TAB'};
    file_Name(44,:) = {'2007/07058_07074_40_FGM_KRTP_1S.TAB'};
    file_Name(45,:) = {'2007/07074_07090_41_FGM_KRTP_1S.TAB'};
    file_Name(46,:) = {'2007/07090_07106_42_FGM_KRTP_1S.TAB'};
    file_Name(47,:) = {'2007/07106_07122_43_FGM_KRTP_1S.TAB'};
    file_Name(48,:) = {'2007/07122_07139_44_FGM_KRTP_1S.TAB'};
    file_Name(49,:) = {'2007/07139_07155_45_FGM_KRTP_1S.TAB'};
    file_Name(50,:) = {'2007/07155_07171_46_FGM_KRTP_1S.TAB'};
    file_Name(51,:) = {'2007/07171_07190_47_FGM_KRTP_1S.TAB'};
    file_Name(52,:) = {'2007/07190_07221_48_FGM_KRTP_1S.TAB'};
    file_Name(53,:) = {'2007/07221_07257_49_FGM_KRTP_1S.TAB'};
    file_Name(54,:) = {'2007/07257_07285_50_FGM_KRTP_1S.TAB'};
    file_Name(55,:) = {'2007/07285_07309_51_FGM_KRTP_1S.TAB'};
    file_Name(56,:) = {'2007/07309_07329_52_FGM_KRTP_1S.TAB'};
    file_Name(57,:) = {'2007/07329_07345_53_FGM_KRTP_1S.TAB'};
    file_Name(58,:) = {'2007/07345_07361_54_FGM_KRTP_1S.TAB'};
    file_Name(59,:) = {'2007/07361_08009_55_FGM_KRTP_1S.TAB'};
    num_of_files = 37;
    
%     2008
    file_Name(60,:) = {'2008/08009_08021_56_FGM_KRTP_1S.TAB'};
    file_Name(61,:) = {'2008/08021_08033_57_FGM_KRTP_1S.TAB'};
    file_Name(62,:) = {'2008/08033_08045_58_FGM_KRTP_1S.TAB'};
    file_Name(63,:) = {'2008/08045_08056_59_FGM_KRTP_1S.TAB'};
    file_Name(64,:) = {'2008/08056_08067_60_FGM_KRTP_1S.TAB'};
    file_Name(65,:) = {'2008/08067_08078_61_FGM_KRTP_1S.TAB'};
    file_Name(66,:) = {'2008/08078_08088_62_FGM_KRTP_1S.TAB'};
    file_Name(67,:) = {'2008/08088_08097_63_FGM_KRTP_1S.TAB'};
    file_Name(68,:) = {'2008/08097_08107_64_FGM_KRTP_1S.TAB'};
    file_Name(69,:) = {'2008/08107_08116_65_FGM_KRTP_1S.TAB'};
    file_Name(70,:) = {'2008/08116_08126_66_FGM_KRTP_1S.TAB'};
    file_Name(71,:) = {'2008/08126_08135_67_FGM_KRTP_1S.TAB'};
    file_Name(72,:) = {'2008/08135_08142_68_FGM_KRTP_1S.TAB'};
    file_Name(73,:) = {'2008/08142_08150_69_FGM_KRTP_1S.TAB'};
    file_Name(74,:) = {'2008/08150_08157_70_FGM_KRTP_1S.TAB'};
    file_Name(75,:) = {'2008/08157_08164_71_FGM_KRTP_1S.TAB'};
    file_Name(76,:) = {'2008/08164_08171_72_FGM_KRTP_1S.TAB'};
    file_Name(77,:) = {'2008/08171_08178_73_FGM_KRTP_1S.TAB'};
    file_Name(78,:) = {'2008/08178_08185_74_FGM_KRTP_1S.TAB'};
    file_Name(79,:) = {'2008/08185_08192_75_FGM_KRTP_1S.TAB'};
    file_Name(80,:) = {'2008/08192_08199_76_FGM_KRTP_1S.TAB'};
    file_Name(81,:) = {'2008/08199_08207_77_FGM_KRTP_1S.TAB'};
    file_Name(82,:) = {'2008/08207_08213_78_FGM_KRTP_1S.TAB'};
    file_Name(83,:) = {'2008/08213_08221_79_FGM_KRTP_1S.TAB'};
    file_Name(84,:) = {'2008/08221_08228_80_FGM_KRTP_1S.TAB'};
    file_Name(85,:) = {'2008/08228_08235_81_FGM_KRTP_1S.TAB'};
    file_Name(86,:) = {'2008/08235_08243_82_FGM_KRTP_1S.TAB'};
    file_Name(87,:) = {'2008/08243_08250_83_FGM_KRTP_1S.TAB'};
    file_Name(88,:) = {'2008/08250_08258_84_FGM_KRTP_1S.TAB'};
    file_Name(89,:) = {'2008/08258_08265_85_FGM_KRTP_1S.TAB'};
    file_Name(90,:) = {'2008/08265_08272_86_FGM_KRTP_1S.TAB'};
    file_Name(91,:) = {'2008/08272_08280_87_FGM_KRTP_1S.TAB'};
    file_Name(92,:) = {'2008/08280_08287_88_FGM_KRTP_1S.TAB'};
    file_Name(93,:) = {'2008/08287_08294_89_FGM_KRTP_1S.TAB'};
    file_Name(94,:) = {'2008/08294_08302_90_FGM_KRTP_1S.TAB'};
    file_Name(95,:) = {'2008/08302_08309_91_FGM_KRTP_1S.TAB'};
    file_Name(96,:) = {'2008/08309_08317_92_FGM_KRTP_1S.TAB'}; 
    file_Name(97,:) = {'2008/08317_08325_93_FGM_KRTP_1S.TAB'};
    file_Name(98,:) = {'2008/08325_08333_94_FGM_KRTP_1S.TAB'};
    file_Name(99,:) = {'2008/08333_08340_95_FGM_KRTP_1S.TAB'};
    file_Name(100,:) = {'2008/08340_08348_96_FGM_KRTP_1S.TAB'};
    file_Name(101,:) = {'2008/08348_08356_97_FGM_KRTP_1S.TAB'};
    file_Name(102,:) = {'2008/08356_08366_98_FGM_KRTP_1S.TAB'};
    file_Name(103,:) = {'2008/08366_09009_99_FGM_KRTP_1S.TAB'};

%      2009
    file_Name(104,:) = {'2009/09009_09019_100_FGM_KRTP_1S.TAB'};
    file_Name(105,:) = {'2009/09019_09028_101_FGM_KRTP_1S.TAB'};
    file_Name(106,:) = {'2009/09028_09039_102_FGM_KRTP_1S.TAB'};
    file_Name(107,:) = {'2009/09039_09051_103_FGM_KRTP_1S.TAB'};
    file_Name(108,:) = {'2009/09051_09062_104_FGM_KRTP_1S.TAB'};
    file_Name(109,:) = {'2009/09062_09074_105_FGM_KRTP_1S.TAB'};
    file_Name(110,:) = {'2009/09074_09086_106_FGM_KRTP_1S.TAB'};
    file_Name(111,:) = {'2009/09086_09094_107_FGM_KRTP_1S.TAB'};
    file_Name(112,:) = {'2009/09094_09106_108_FGM_KRTP_1S.TAB'};
    file_Name(113,:) = {'2009/09106_09122_109_FGM_KRTP_1S.TAB'};
    file_Name(114,:) = {'2009/09122_09137_110_FGM_KRTP_1S.TAB'};
    file_Name(115,:) = {'2009/09137_09153_111_FGM_KRTP_1S.TAB'};
    file_Name(116,:) = {'2009/09153_09168_112_FGM_KRTP_1S.TAB'};
    file_Name(117,:) = {'2009/09168_09184_113_FGM_KRTP_1S.TAB'};
    file_Name(118,:) = {'2009/09184_09199_114_FGM_KRTP_1S.TAB'};
    file_Name(119,:) = {'2009/09199_09215_115_FGM_KRTP_1S.TAB'};
    file_Name(120,:) = {'2009/09215_09231_116_FGM_KRTP_1S.TAB'};
    file_Name(121,:) = {'2009/09231_09251_117_FGM_KRTP_1S.TAB'};
    file_Name(122,:) = {'2009/09251_09275_118_FGM_KRTP_1S.TAB'};
    file_Name(123,:) = {'2009/09275_09296_119_FGM_KRTP_1S.TAB'};
    file_Name(124,:) = {'2009/09296_09315_120_FGM_KRTP_1S.TAB'};
    file_Name(125,:) = {'2009/09315_09334_121_FGM_KRTP_1S.TAB'};
    file_Name(126,:) = {'2009/09334_09352_122_FGM_KRTP_1S.TAB'};
    file_Name(127,:) = {'2009/09352_10003_123_FGM_KRTP_1S.TAB'};
    
    % 2010
    file_Name(128,:) = {'2010/10003_10019_124_FGM_KRTP_1S.TAB'};
    file_Name(129,:) = {'2010/10019_10035_125_FGM_KRTP_1S.TAB'};
    file_Name(130,:) = {'2010/10035_10053_126_FGM_KRTP_1S.TAB'};
    file_Name(131,:) = {'2010/10053_10071_127_FGM_KRTP_1S.TAB'};
    file_Name(132,:) = {'2010/10071_10088_128_FGM_KRTP_1S.TAB'};
    file_Name(133,:) = {'2010/10088_10107_129_FGM_KRTP_1S.TAB'};
    file_Name(134,:) = {'2010/10107_10128_130_FGM_KRTP_1S.TAB'};
    file_Name(135,:) = {'2010/10128_10146_131_FGM_KRTP_1S.TAB'};
    file_Name(136,:) = {'2010/10146_10162_132_FGM_KRTP_1S.TAB'};
    file_Name(137,:) = {'2010/10162_10178_133_FGM_KRTP_1S.TAB'};
    file_Name(138,:) = {'2010/10178_10196_134_FGM_KRTP_1S.TAB'};
    file_Name(139,:) = {'2010/10196_10216_135_FGM_KRTP_1S.TAB'};
    file_Name(140,:) = {'2010/10216_10236_136_FGM_KRTP_1S.TAB'};
    file_Name(141,:) = {'2010/10236_10256_137_FGM_KRTP_1S.TAB'};
    file_Name(142,:) = {'2010/10256_10277_138_FGM_KRTP_1S.TAB'};
    file_Name(143,:) = {'2010/10277_10301_139_FGM_KRTP_1S.TAB'};
    file_Name(144,:) = {'2010/10301_10324_140_FGM_KRTP_1S.TAB'};
    file_Name(145,:) = {'2010/10324_10344_141_FGM_KRTP_1S.TAB'};
    file_Name(146,:) = {'2010/10344_10365_142_FGM_KRTP_1S.TAB'};

    
    % 2011
    file_Name(147,:) = {'2011/11020_11041_144_FGM_KRTP_1S.TAB'};
    file_Name(148,:) = {'2011/11041_11065_145_FGM_KRTP_1S.TAB'};
    file_Name(149,:) = {'2011/11065_11093_146_FGM_KRTP_1S.TAB'};
    file_Name(150,:) = {'2011/11093_11119_147_FGM_KRTP_1S.TAB'};
    file_Name(151,:) = {'2011/11119_11150_148_FGM_KRTP_1S.TAB'};
    file_Name(152,:) = {'2011/11150_11180_149_FGM_KRTP_1S.TAB'};
    file_Name(153,:) = {'2011/11180_11202_150_FGM_KRTP_1S.TAB'};
    file_Name(154,:) = {'2011/11202_11224_151_FGM_KRTP_1S.TAB'};
    file_Name(155,:) = {'2011/11224_11246_152_FGM_KRTP_1S.TAB'};
    file_Name(156,:) = {'2011/11246_11265_153_FGM_KRTP_1S.TAB'};
    file_Name(157,:) = {'2011/11265_11283_154_FGM_KRTP_1S.TAB'};
    file_Name(158,:) = {'2011/11283_11301_155_FGM_KRTP_1S.TAB'};
    file_Name(159,:) = {'2011/11301_11319_156_FGM_KRTP_1S.TAB'};
    file_Name(160,:) = {'2011/11319_11337_157_FGM_KRTP_1S.TAB'};
    file_Name(161,:) = {'2011/11337_11357_158_FGM_KRTP_1S.TAB'};
    file_Name(162,:) = {'2011/11357_12016_159_FGM_KRTP_1S.TAB'};
    
    % 2012
    file_Name(163,:) = {'2012/12016_12040_160_FGM_KRTP_1S.TAB'};
    file_Name(164,:) = {'2012/12040_12061_161_FGM_KRTP_1S.TAB'};
    file_Name(165,:) = {'2012/12061_12078_162_FGM_KRTP_1S.TAB'};
    file_Name(166,:) = {'2012/12078_12096_163_FGM_KRTP_1S.TAB'};
    file_Name(167,:) = {'2012/12096_12114_164_FGM_KRTP_1S.TAB'};
    file_Name(168,:) = {'2012/12114_12132_165_FGM_KRTP_1S.TAB'};
    file_Name(169,:) = {'2012/12132_12149_166_FGM_KRTP_1S.TAB'};
    file_Name(170,:) = {'2012/12149_12169_167_FGM_KRTP_1S.TAB'};
    file_Name(171,:) = {'2012/12169_12192_168_FGM_KRTP_1S.TAB'};
    file_Name(172,:) = {'2012/12192_12215_169_FGM_KRTP_1S.TAB'};
    file_Name(173,:) = {'2012/12215_12236_170_FGM_KRTP_1S.TAB'};
    file_Name(174,:) = {'2012/12236_12257_171_FGM_KRTP_1S.TAB'};
    file_Name(175,:) = {'2012/12257_12280_172_FGM_KRTP_1S.TAB'};
    file_Name(176,:) = {'2012/12280_12304_173_FGM_KRTP_1S.TAB'};
    file_Name(177,:) = {'2012/12304_12324_174_FGM_KRTP_1S.TAB'};
    file_Name(178,:) = {'2012/12324_12338_175_FGM_KRTP_1S.TAB'};
    file_Name(179,:) = {'2012/12338_12351_176_FGM_KRTP_1S.TAB'};
    file_Name(180,:) = {'2012/12351_12364_177_FGM_KRTP_1S.TAB'};
    file_Name(181,:) = {'2012/12364_13012_178_FGM_KRTP_1S.TAB'};

    
    full_file_Name = horzcat(path_Name, file_Name{file_number, :});
    full_file_Name = horzcat(full_file_Name{:,1}, full_file_Name{:,2})
    
    % read data from the file using file format  
    magnetometer_data = zeros(11, 1);
    formatSpec = ['%d-%d-%dT%d:%d:%f %f %f %f %f %d'];
    data_size = [11 Inf];


%     full_file_Name = horzcat(path_Name, file_Name(file_number,:))
    fileID = fopen(full_file_Name, 'r');
    magnetometer_data = fscanf(fileID, formatSpec, data_size);

    
%     date_of_magnetometer_measurement = datetime(datenum(magnetometer_data(1,:), magnetometer_data(2,:), magnetometer_data(3,:), magnetometer_data(4,:), magnetometer_data(5,:), floor(magnetometer_data(6,:))), 'ConvertFrom', 'datenum');
%     date_of_magnetometer_measurement = datenum(magnetometer_data(1,:), magnetometer_data(2,:), magnetometer_data(3,:), magnetometer_data(4,:), magnetometer_data(5,:), floor(magnetometer_data(6,:)));
    fclose(fileID)
end

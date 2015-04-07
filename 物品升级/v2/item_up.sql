SET FOREIGN_KEY_CHECKS=0;


DROP TABLE IF EXISTS `item_up`;
CREATE TABLE `item_up` (
  `原ID` mediumint(255) NOT NULL,
  `升级ID` mediumint(255) NOT NULL DEFAULT '0',
  `成功率` int(255) NOT NULL DEFAULT '0',
  `原物品数量` int(255) NOT NULL DEFAULT '0',
  `材料ID1` mediumint(255) NOT NULL DEFAULT '0',
  `材料数量1` int(255) NOT NULL DEFAULT '0',
  `材料ID2` mediumint(255) NOT NULL DEFAULT '0',
  `材料数量2` int(255) NOT NULL DEFAULT '0',
  `材料ID3` mediumint(255) NOT NULL DEFAULT '0',
  `材料数量3` int(255) NOT NULL DEFAULT '0',
  `材料ID4` mediumint(255) NOT NULL DEFAULT '0',
  `材料数量4` int(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`原ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



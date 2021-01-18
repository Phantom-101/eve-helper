import 'package:eve_helper/views/tool_selection_views/exploration_tool_selection_view.dart';
import 'package:eve_helper/views/tool_selection_views/industry_tool_selection_view.dart';
import 'package:eve_helper/views/tool_selection_views/market_tool_selection_view.dart';
import 'package:eve_helper/views/tool_selection_views/miscellaneous_tool_selection_view.dart';
import 'package:eve_helper/views/tool_selection_views/navigation_tool_selection_view.dart';
import 'package:eve_helper/views/tool_selection_views/pve_tool_selection_view.dart';
import 'package:eve_helper/widgets/card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ToolSelectionView extends StatelessWidget {
  ToolSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EVE Helper'),
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 4,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CardTile(
                  title: Text('Eve Helper'),
                  subtitle: Text('A handy tool for all of your Eve Online needs!\nThis small but powerful app contains tools that will help you streamline every aspect of your gameplay!\nBelow is the list of categories for which we have tools for (or will have, as some of them are still being worked on).'),
                ),
              ),
              Expanded(
                child: CardTile(
                  title: Text('Important'),
                  subtitle: Text('This material is used with limited permission of CCP Games. No official affiliation or endorsement by CCP Games is stated or implied.\nEVE Online and the EVE logo are the registered trademarks of CCP hf. All rights are reserved worldwide. All other trademarks are the property of their respective owners. EVE Online, the EVE logo, EVE and all associated logos and designs are the intellectual property of CCP hf. All artwork, screenshots, characters, vehicles, storylines, world facts or other recognizable features of the intellectual property relating to these trademarks are likewise the intellectual property of CCP hf.\nCCP is in no way responsible for the content on or functioning of this application, nor can it be liable for any damage arising from the use of this application.'),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.blueGrey[100],
            height: 32,
            thickness: 1,
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/market.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Market'),
            subtitle: Text('Tools for retrieving and processing market data.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MarketToolSelectionView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/Industry.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Industry'),
            subtitle: Text('Tools for industry-related activities.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IndustryToolSelectionView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/combatlog.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('PvE'),
            subtitle: Text('Tools for PvE-related activities.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PvEToolSelectionView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/systems.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Navigation'),
            subtitle: Text('Tools for pathfinding and navigating throughout the universe.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationToolSelectionView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/mutation.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Exploration'),
            subtitle: Text('Various helpers to guide your journey to explore the universe.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExplorationToolSelectionView())),
          ),
          CardTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/Icons/UI/WindowIcons/smallfolder.png', color: Colors.black, fit: BoxFit.fill),
            ),
            title: Text('Miscellaneous'),
            subtitle: Text('Various un-categorized tools.'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MiscellaneousToolSelectionView())),
          ),
        ],
        staggeredTiles: [
          StaggeredTile.fit(4),
          StaggeredTile.fit(4),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
          StaggeredTile.fit(1),
        ],
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.all(4.0),
      ),
    );
  }
}

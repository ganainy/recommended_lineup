const competitionId = 'competition_id';
const attacker = 'attacker';
const midfielder = 'midfielder';
const defender = 'defender';
const goalkeeper = 'goalkeeper';

//assuming all formations follow this pattern (x-x-x)
class FormationModel {
  String name;

  FormationModel({required this.name});

  int getDefenderCount() {
    List<String> formation = name.split('-');
    return int.parse(formation[0]);
  }

  int getMidfieldersCount() {
    List<String> formation = name.split('-');
    return int.parse(formation[1]);
  }

  int getAttackersCount() {
    List<String> formation = name.split('-');
    return int.parse(formation[2]);
  }
}

var formations = [
  FormationModel(name: '4-3-3'),
  FormationModel(name: '4-4-2'),
  FormationModel(name: '3-4-3'),
  FormationModel(name: '5-3-2'),
  FormationModel(name: '3-4-3'),
];

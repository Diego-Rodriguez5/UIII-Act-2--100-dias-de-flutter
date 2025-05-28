import 'package:flutter/material.dart';
import 'package:myapp/Model/animatedlist_model.dart';

class MyAnimatedList extends StatefulWidget {
  const MyAnimatedList({super.key});

  @override
  State<MyAnimatedList> createState() => _MyAnimatedListState();
}

class _MyAnimatedListState extends State<MyAnimatedList> {
  final List<User> selectedUsers = [];
  final GlobalKey<AnimatedListState> itemKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> selectedKey =
      GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 25, left: 25, top: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Text("Selected Members"),
                    SizedBox(height: 20),
                    // Para mostrar elementos seleccionados
                    Expanded(
                      child: AnimatedList(
                        key: selectedKey,
                        scrollDirection: Axis.horizontal,
                        initialItemCount: selectedUsers.length,
                        itemBuilder: (context, index, animation) {
                          return displaySelectedItems(
                            animation: animation,
                            index: index,
                            user: selectedUsers[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // para los itmens display
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedList(
                  key: itemKey,
                  initialItemCount: users.length,
                  itemBuilder: (context, index, animation) {
                    return userItems(
                      animation: animation,
                      index: index,
                      user: users[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding displaySelectedItems({
    required Animation<double> animation,
    required int index,
    required User user,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: FadeTransition(
        opacity: animation,
        child: Column(
          children: [
            SizedBox(
              width: 50,
              child: Text(
                users[index].name,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            Stack(
              children: [
                Positioned(
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
                      backgroundImage: NetworkImage(users[index].image),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      itemKey.currentState?.insertItem(
                        users.length,
                        duration: const Duration(milliseconds: 500),
                      );
                      selectedKey.currentState?.removeItem(
                        index,
                        (context, animation) => displaySelectedItems(
                          animation: animation,
                          index: index,
                          user: user,
                        ),
                      );
                      selectedUsers.remove(user);
                      users.add(user);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Center(child: Icon(Icons.close, size: 15)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector userItems({
    required Animation<double> animation,
    required int index,
    required User user,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedUsers.length > 4) return;
          itemKey.currentState?.removeItem(
            index,
            (context, animation) =>
                userItems(animation: animation, index: index, user: user),
          );

          selectedKey.currentState?.insertItem(
            selectedUsers.length,
            duration: const Duration(microseconds: 500),
          );
          selectedUsers.add(user);
          users.remove(user);
        });
      },
      child: FadeTransition(
        opacity: animation,
        child: Container(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  backgroundImage: NetworkImage(users[index].image),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    users[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    users[index].username,
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

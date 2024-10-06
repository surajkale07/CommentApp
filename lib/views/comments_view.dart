import 'package:flutter/material.dart';
import '../controllers/comments_controller.dart';
import '../controllers/remote_config_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/comment_model.dart';

class CommentsView extends StatefulWidget {
  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final _commentsController = CommentsController();
  final _remoteConfigController = RemoteConfigController();
  final _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _remoteConfigController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xff0C54BE),
        title: Text('Comments',style: TextStyle(color: Colors.white,
          fontFamily: 'poppins',
          fontWeight: FontWeight.bold ),),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white,),
            onPressed: () => {_authController.logoutUser(),
            Navigator.popAndPushNamed(context, '/login'),
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logout Successful")),
            )

          },
          ),
        ],
      ),
      body: FutureBuilder<List<CommentModel>>(
        future: _commentsController.fetchComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          bool showFullEmail = _remoteConfigController.shouldShowFullEmail();

          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final comment = snapshot.data?[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image
                      CircleAvatar(
                        backgroundColor: Color(0xffCED3DC),
                        child: Text(
                          comment!.name[0].toUpperCase(), // Get the first letter of the name and make it uppercase
                          style: TextStyle(
                            color: Colors.white, // Text color inside the circle
                            fontSize: 24, // Adjust font size to fit well in the circle
                            fontWeight: FontWeight.bold, // Make the initial bold
                            fontFamily: 'Poppins',
                          ),
                        ),
                        radius: 30,
                      ),
                      SizedBox(width: 16),

                      // Textual information (name, email, body)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Name: ', // Normal text
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal, // Normal weight for 'Name:'
                                      fontFamily: 'Poppins',
                                      color: Colors.black, // Set text color explicitly
                                    ),
                                  ),
                                  TextSpan(
                                    text: comment!.name ?? 'Name', // Bold text
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold, // Bold weight for comment.name
                                      fontFamily: 'Poppins',
                                      color: Colors.black, // Set text color explicitly
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 4),

                            // Email (masked or full)
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Email: ', // Normal text for "Email:"
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal, // Normal weight for 'Email:'
                                      fontFamily: 'Poppins',
                                      color: Colors.black, // Use the same grey color
                                    ),
                                  ),
                                  TextSpan(
                                    text: _remoteConfigController.maskEmail(comment?.email ?? '', showFullEmail), // Masked email
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold, // Bold for the masked email
                                      fontFamily: 'Poppins',
                                      color: Colors.black, // Keep the same grey color for consistency
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8),

                            // Body
                            Text(
                              comment?.body ?? 'Body text',
                              style: TextStyle(fontSize: 14,           fontFamily: 'poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

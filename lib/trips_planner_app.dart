import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_auth_cognito_dart/src/state/cognito_state_machine.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_amplify_test/amplifyconfiguration.dart';
import 'package:aws_amplify_test/features/trip/ui/trips_list/trips_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aws_amplify_test/common/utils/colors.dart' as constants;


import 'common/navigation/router/routes.dart';
import 'models/ModelProvider.dart';

class TripsPlannerApp extends StatelessWidget {
  const TripsPlannerApp({
    required this.isAmplifySuccessfullyConfigured,
    Key? key,
  }) : super(key: key);

  final bool isAmplifySuccessfullyConfigured;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: AppRoute.home.name,
          builder: (context, state) => isAmplifySuccessfullyConfigured
              ? const TripsListPage()
              : const Scaffold(
                  body: Center(
                    child: Text(
                      'Tried to reconfigure Amplify; '
                      'this can occur when your app restarts on Android.',
                    ),
                  ),
                ),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text(state.error.toString()),
        ),
      ),
    );

    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign In form from amplify_authenticator
              body: SignInForm(),
              // A custom footer with a button to take the user to sign up
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signUp,
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign Up form from amplify_authenticator
              body: SignUpForm(),
              // A custom footer with a button to take the user to sign in
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signIn,
                    ),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Sign Up form from amplify_authenticator
              body: ConfirmSignUpForm(),
            );
          case AuthenticatorStep.resetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Reset Password form from amplify_authenticator
              body: ResetPasswordForm(),
            );
          case AuthenticatorStep.confirmResetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Reset Password form from amplify_authenticator
              body: const ConfirmResetPasswordForm(),
            );
          default:
            // Returning null defaults to the prebuilt authenticator for all other steps
            return null;
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        builder: Authenticator.builder(),
        theme: ThemeData(
          primarySwatch: constants.primaryColor,
          backgroundColor: const Color(0xff82CFEA),
        ),
      ),
    );
  }
}

/// A widget that displays a logo, a body, and an optional footer.
class CustomScaffold extends StatefulWidget {
  CustomScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  late String selectedDataRegion = 'us-east-1';
  // late final AuthCategory _amplifyAuth;

  List<AmplifyPluginInterface> _plugins = <AmplifyPluginInterface>[];

  List<String> dataRegions = [
    'us-east-1',
    'ap-southeast-2',
    // 'ap-southeast-2',
    // Add more regions as needed
  ];

  Future<void> init() async {
    // if (!Amplify.isConfigured) {
    //   await Amplify.addPlugins([
    //     AmplifyAuthCognito(),
    //     AmplifyDataStore(modelProvider: ModelProvider.instance),
    //     AmplifyAPI(),
    //   ]);


    // await Amplify.configure(amplifyconfig_2);
    // }
  }

  // Future<void> reset() async {
  //   // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  //   await Amplify.reset();
  // }

  // Future<void> resetPlugins() async {
  //   // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  //   await Future.wait<void>(_plugins.map((plugin) => plugin.reset()));
  //   _plugins.clear();
  // }

  Future<void> changeRegion(String selectedDataRegion) async {
    debugPrint('changeRegion: $selectedDataRegion');
    // await reset();
    // await init();

    final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
    final CognitoUserPoolConfig? currentUserPoolConfig = cognitoPlugin.stateMachine.get<CognitoUserPoolConfig>();
    final CognitoAuthStateMachine stateMachine = cognitoPlugin.stateMachine;

    final userPoolConfig = cognitoPlugin.stateMachine.get<CognitoUserPoolConfig>();
    final bleble = cognitoPlugin.stateMachine.get<Token<CognitoUserPoolConfig>>();


    if(currentUserPoolConfig?.region != selectedDataRegion){
      final CognitoUserPoolConfig config = currentUserPoolConfig!.copyWith(poolId: 'chris', region: selectedDataRegion, endpoint: 'https://cognito-idp.$selectedDataRegion.amazonaws.com');

      cognitoPlugin.stateMachine.create(config as Token<Object>?);


    }

    // cognitoPlugin.stateMachine.create<CognitoUserPoolConfig>(currentUserPoolConfig!.copyWith(poolId: 'chris') as Token<CognitoUserPoolConfig>?);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App logo
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: Center(
                  child: DropdownButton<String>(
                    value: selectedDataRegion,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDataRegion = newValue!;
                      });

                      /// add reconfigure amplify
                      changeRegion(selectedDataRegion);
                    },
                    items: dataRegions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: widget.body,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: widget.footer != null ? [widget.footer!] : null,
    );
  }
}

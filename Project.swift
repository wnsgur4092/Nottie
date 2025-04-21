import ProjectDescription

let project = Project(
    name: "Nottie",
    targets: [
        .target(
            name: "Nottie",
            destinations: .iOS,
            product: .app,
            bundleId: "com.outlook.Nottie",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Nottie/Sources/**"],
            resources: ["Nottie/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "NottieTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.NottieTests",
            infoPlist: .default,
            sources: ["Nottie/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Nottie")]
        ),
    ]
)

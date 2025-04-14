(pair
  key: (string
    (string_content) @key (#match? @key "dependencies|devDependencies|peerDependencies|optionalDependencies")
  )
  value: (object
    (pair
      key: (string (string_content) @depen)
    )
  )
)

{{- $tableNameSingular := .Table.Name | singular | titleCase -}}
{{- $varNameSingular := .Table.Name | singular | camelCase -}}
// DeleteG deletes a single {{$tableNameSingular}} record.
// DeleteG will match against the primary key column to find the record to delete.
func (o *{{$tableNameSingular}}) DeleteG() error {
  if o == nil {
    return errors.New("{{.PkgName}}: no {{$tableNameSingular}} provided for deletion")
  }

  return o.Delete(boil.GetDB())
}

// DeleteGP deletes a single {{$tableNameSingular}} record.
// DeleteGP will match against the primary key column to find the record to delete.
// Panics on error.
func (o *{{$tableNameSingular}}) DeleteGP() {
  if err := o.DeleteG(); err != nil {
    panic(boil.WrapErr(err))
  }
}

// Delete deletes a single {{$tableNameSingular}} record with an executor.
// Delete will match against the primary key column to find the record to delete.
func (o *{{$tableNameSingular}}) Delete(exec boil.Executor) error {
  if o == nil {
    return errors.New("{{.PkgName}}: no {{$tableNameSingular}} provided for deletion")
  }

  var mods []qm.QueryMod

  mods = append(mods,
    qm.From("{{.Table.Name}}"),
    qm.Where(`{{whereClause 1 .Table.PKey.Columns}}`, {{.Table.PKey.Columns | stringMap .StringFuncs.titleCase | prefixStringSlice "o." | join ", "}}),
  )

  query := NewQuery(exec, mods...)
  boil.SetDelete(query)

  _, err := boil.ExecQuery(query)
  if err != nil {
    return fmt.Errorf("{{.PkgName}}: unable to delete from {{.Table.Name}}: %s", err)
  }

  return nil
}

// DeleteP deletes a single {{$tableNameSingular}} record with an executor.
// DeleteP will match against the primary key column to find the record to delete.
// Panics on error.
func (o *{{$tableNameSingular}}) DeleteP(exec boil.Executor) {
  if err := o.Delete(exec); err != nil {
    panic(boil.WrapErr(err))
  }
}

// DeleteAll deletes all rows.
func (o {{$varNameSingular}}Query) DeleteAll() error {
  if o.Query == nil {
    return errors.New("{{.PkgName}}: no {{$varNameSingular}}Query provided for delete all")
  }

  boil.SetDelete(o.Query)

  _, err := boil.ExecQuery(o.Query)
  if err != nil {
    return fmt.Errorf("{{.PkgName}}: unable to delete all from {{.Table.Name}}: %s", err)
  }

  return nil
}

// DeleteAllP deletes all rows, and panics on error.
func (o {{$varNameSingular}}Query) DeleteAllP() {
    if err := o.DeleteAll(); err != nil {
      panic(boil.WrapErr(err))
    }
}

// DeleteAll deletes all rows in the slice, and panics on error.
func (o {{$tableNameSingular}}Slice) DeleteAllGP() {
  if err := o.DeleteAllG(); err != nil {
    panic(boil.WrapErr(err))
  }
}

// DeleteAllG deletes all rows in the slice.
func (o {{$tableNameSingular}}Slice) DeleteAllG() error {
  if o == nil {
    return errors.New("{{.PkgName}}: no {{$tableNameSingular}} slice provided for delete all")
  }
  return o.DeleteAll(boil.GetDB())
}

// DeleteAll deletes all rows in the slice with an executor.
func (o {{$tableNameSingular}}Slice) DeleteAll(exec boil.Executor) error {
  if o == nil {
    return errors.New("{{.PkgName}}: no {{$tableNameSingular}} slice provided for delete all")
  }

  var mods []qm.QueryMod

  args := o.inPrimaryKeyArgs()
  in := boil.WherePrimaryKeyIn(len(o), {{.Table.PKey.Columns | stringMap .StringFuncs.quoteWrap | join ", "}})

  mods = append(mods,
    qm.From("{{.Table.Name}}"),
    qm.Where(in, args...),
  )

  query := NewQuery(exec, mods...)
  boil.SetDelete(query)

  _, err := boil.ExecQuery(query)
  if err != nil {
    return fmt.Errorf("{{.PkgName}}: unable to delete all from {{$varNameSingular}} slice: %s", err)
  }
  if boil.DebugMode {
		fmt.Fprintln(boil.DebugWriter, args)
  }

  return nil
}

// DeleteAllP deletes all rows in the slice with an executor, and panics on error.
func (o {{$tableNameSingular}}Slice) DeleteAllP(exec boil.Executor) {
  if err := o.DeleteAll(exec); err != nil {
    panic(boil.WrapErr(err))
  }
}

<cfscript>
public query function changeColumnName(q,c,n){	
		var s = StructNew();
		s.Columns = arguments.q.GetColumnNames();
		s.ColumnList = ArrayToList(
		s.Columns
		);
		 
		// Get the index of the column name.
		s.ColumnIndex = ListFindNoCase(
		s.ColumnList,
		arguments.c
		);
		 
		if (s.ColumnIndex){
		s.Columns = ListToArray(
		s.ColumnList
		);
		 
		s.Columns[ s.ColumnIndex ] = arguments.n;
		 
		// Set the column names.
		arguments.q.SetColumnNames(
		s.Columns
		);
		 
		}
		 
		// Return the query reference.
		return( arguments.q );
}
</cfscript>
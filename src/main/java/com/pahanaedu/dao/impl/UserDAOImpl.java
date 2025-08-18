package com.pahanaedu.dao.impl;
import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;
import com.pahanaedu.util.ConnectionFactory;
import java.sql.*; import java.util.*;

public class UserDAOImpl implements UserDAO {
  private final ConnectionFactory cf = ConnectionFactory.getInstance();

  @Override public Optional<User> findByUsername(String u){
    String sql="SELECT * FROM users WHERE username=?";
    try(Connection con=cf.getConnection(); PreparedStatement ps=con.prepareStatement(sql)){
      ps.setString(1,u);
      try(ResultSet rs=ps.executeQuery()){
        if(rs.next()){
          User user=new User();
          user.setId(rs.getLong("id"));
          user.setUsername(rs.getString("username"));
          user.setPasswordHash(rs.getString("password_hash"));
          user.setRole(rs.getString("role"));
          return Optional.of(user);
        }
        return Optional.empty();
      }
    }catch(SQLException e){ throw new RuntimeException("Find user failed",e); }
  }

  @Override public User save(User u){
    String sql="INSERT INTO users(username,password_hash,role) VALUES(?,?,?)";
    try(Connection con=cf.getConnection();
        PreparedStatement ps=con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
      ps.setString(1,u.getUsername());
      ps.setString(2,u.getPasswordHash());
      ps.setString(3,u.getRole());
      ps.executeUpdate();
      try(ResultSet rs=ps.getGeneratedKeys()){ if(rs.next()) u.setId(rs.getLong(1)); }
      return u;
    }catch(SQLException e){ throw new RuntimeException("Save user failed",e); }
  }

  @Override public List<User> findAll(){
    List<User> list=new ArrayList<>();
    try(Connection con=cf.getConnection(); Statement st=con.createStatement();
        ResultSet rs=st.executeQuery("SELECT * FROM users")){
      while(rs.next()){
        User u=new User();
        u.setId(rs.getLong("id"));
        u.setUsername(rs.getString("username"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        list.add(u);
      }
    }catch(SQLException e){ throw new RuntimeException("Find all users failed",e); }
    return list;
  }
  
  
  //New
  @Override public Optional<User> findById(Long id){
	  String sql="SELECT * FROM users WHERE id=?";
	  try(var con=cf.getConnection(); var ps=con.prepareStatement(sql)){
	    ps.setLong(1,id);
	    try(var rs=ps.executeQuery()){
	      if(rs.next()){
	        User u=new User();
	        u.setId(rs.getLong("id"));
	        u.setUsername(rs.getString("username"));
	        u.setPasswordHash(rs.getString("password_hash"));
	        u.setRole(rs.getString("role"));
	        return Optional.of(u);
	      } return Optional.empty();
	    }
	  } catch(Exception e){ throw new RuntimeException(e); }
	}
	@Override public boolean delete(Long id){
	  try(var con=cf.getConnection(); var ps=con.prepareStatement("DELETE FROM users WHERE id=?")){
	    ps.setLong(1,id); return ps.executeUpdate()==1;
	  }catch(Exception e){ throw new RuntimeException(e); }
	}

}

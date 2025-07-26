"use client"

import { useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Badge } from "@/components/ui/badge"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Switch } from "@/components/ui/switch"
import {
  User,
  Shield,
  Bus,
  Users,
  MapPin,
  Bell,
  Settings,
  BarChart3,
  AlertTriangle,
  Clock,
  Phone,
  Mail,
  Eye,
  EyeOff,
  Download,
  Activity,
} from "lucide-react"

export default function AdminProfile() {
  const [isEditing, setIsEditing] = useState(false)
  const [showPassword, setShowPassword] = useState(false)
  const [notifications, setNotifications] = useState({
    emergencyAlerts: true,
    systemUpdates: true,
    dailyReports: false,
    maintenanceAlerts: true,
  })

  return (
    <div className="p-6 w-full max-w-6xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <div className="w-20 h-20 bg-gradient-to-br from-blue-500 to-blue-600 rounded-full flex items-center justify-center text-white text-2xl font-bold">
            S
          </div>
          <div>
            <h1 className="text-3xl font-bold">Swaners</h1>
            <p className="text-muted-foreground">Sakay Bus Tracking System</p>
            <div className="flex items-center gap-2 mt-1">
              <Badge variant="secondary" className="bg-green-100 text-green-800">
                <Activity className="w-3 h-3 mr-1" />
                Online
              </Badge>
              <Badge variant="outline">Super Admin</Badge>
            </div>
          </div>
        </div>
        <Button onClick={() => setIsEditing(!isEditing)} variant={isEditing ? "outline" : "default"}>
          {isEditing ? "Cancel" : "Edit Profile"}
        </Button>
      </div>

      <Tabs defaultValue="profile" className="w-full">
        <TabsList className="grid w-full grid-cols-6">
          <TabsTrigger value="profile" className="flex items-center gap-2">
            <User className="w-4 h-4" />
            Profile
          </TabsTrigger>
          <TabsTrigger value="dashboard" className="flex items-center gap-2">
            <BarChart3 className="w-4 h-4" />
            Dashboard
          </TabsTrigger>
          <TabsTrigger value="fleet" className="flex items-center gap-2">
            <Bus className="w-4 h-4" />
            Fleet
          </TabsTrigger>
          <TabsTrigger value="security" className="flex items-center gap-2">
            <Shield className="w-4 h-4" />
            Security
          </TabsTrigger>
          <TabsTrigger value="notifications" className="flex items-center gap-2">
            <Bell className="w-4 h-4" />
            Alerts
          </TabsTrigger>
          <TabsTrigger value="settings" className="flex items-center gap-2">
            <Settings className="w-4 h-4" />
            Settings
          </TabsTrigger>
        </TabsList>

        {/* Profile Tab */}
        <TabsContent value="profile" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Personal Information</CardTitle>
              <CardDescription>Manage your account details and contact information</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="firstName">First Name</Label>
                  <Input id="firstName" defaultValue="Luis" disabled={!isEditing} />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="lastName">Last Name</Label>
                  <Input id="lastName" defaultValue="Admin" disabled={!isEditing} />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="email">Email Address</Label>
                  <div className="relative">
                    <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                    <Input
                      id="email"
                      type="email"
                      defaultValue="admin@ltdc.com.ph"
                      className="pl-10"
                      disabled={!isEditing}
                    />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="phone">Contact Number</Label>
                  <div className="relative">
                    <Phone className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                    <Input id="phone" defaultValue="+63 912 345 6789" className="pl-10" disabled={!isEditing} />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="employeeId">Employee ID</Label>
                  <Input id="employeeId" defaultValue="LTDC-ADM-001" disabled />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="department">Department</Label>
                  <Input id="department" defaultValue="IT Operations" disabled={!isEditing} />
                </div>
              </div>
              {isEditing && (
                <div className="flex gap-2">
                  <Button className="bg-green-600 hover:bg-green-700">Save Changes</Button>
                  <Button variant="outline" onClick={() => setIsEditing(false)}>
                    Cancel
                  </Button>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        {/* Dashboard Tab */}
        <TabsContent value="dashboard" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-medium text-muted-foreground">Active Buses</p>
                    <p className="text-2xl font-bold text-green-600">18</p>
                  </div>
                  <Bus className="h-8 w-8 text-green-600" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-medium text-muted-foreground">Daily Users</p>
                    <p className="text-2xl font-bold text-blue-600">1,247</p>
                  </div>
                  <Users className="h-8 w-8 text-blue-600" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-medium text-muted-foreground">Active Routes</p>
                    <p className="text-2xl font-bold text-purple-600">12</p>
                  </div>
                  <MapPin className="h-8 w-8 text-purple-600" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-medium text-muted-foreground">Pending Issues</p>
                    <p className="text-2xl font-bold text-orange-600">3</p>
                  </div>
                  <AlertTriangle className="h-8 w-8 text-orange-600" />
                </div>
              </CardContent>
            </Card>
          </div>

          <Card>
            <CardHeader>
              <CardTitle>System Status Overview</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center justify-between p-3 bg-green-50 rounded-lg">
                  <span className="font-medium">GPS Tracking System</span>
                  <Badge className="bg-green-600">Operational</Badge>
                </div>
                <div className="flex items-center justify-between p-3 bg-green-50 rounded-lg">
                  <span className="font-medium">Real-time Communication</span>
                  <Badge className="bg-green-600">Operational</Badge>
                </div>
                <div className="flex items-center justify-between p-3 bg-yellow-50 rounded-lg">
                  <span className="font-medium">Database Performance</span>
                  <Badge className="bg-yellow-600">Monitoring</Badge>
                </div>
                <div className="flex items-center justify-between p-3 bg-green-50 rounded-lg">
                  <span className="font-medium">Mobile App Services</span>
                  <Badge className="bg-green-600">Operational</Badge>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Fleet Management Tab */}
        <TabsContent value="fleet" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Fleet Management Controls</CardTitle>
              <CardDescription>Quick access to fleet operations and monitoring</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <Button variant="outline" className="h-20 flex-col bg-transparent">
                  <Bus className="h-6 w-6 mb-2" />
                  Manage Buses
                </Button>
                <Button variant="outline" className="h-20 flex-col bg-transparent">
                  <Users className="h-6 w-6 mb-2" />
                  Driver Management
                </Button>
                <Button variant="outline" className="h-20 flex-col bg-transparent">
                  <MapPin className="h-6 w-6 mb-2" />
                  Route Planning
                </Button>
                <Button variant="outline" className="h-20 flex-col bg-transparent">
                  <Clock className="h-6 w-6 mb-2" />
                  Schedule Management
                </Button>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Recent Fleet Activities</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="flex items-center justify-between p-3 border rounded-lg">
                  <div>
                    <p className="font-medium">Bus LTD-001 completed route</p>
                    <p className="text-sm text-muted-foreground">Lingayen to Dagupan - 2 hours ago</p>
                  </div>
                  <Badge variant="secondary">Completed</Badge>
                </div>
                <div className="flex items-center justify-between p-3 border rounded-lg">
                  <div>
                    <p className="font-medium">Driver Juan Cruz logged in</p>
                    <p className="text-sm text-muted-foreground">Bus LTD-003 - 3 hours ago</p>
                  </div>
                  <Badge className="bg-green-600">Active</Badge>
                </div>
                <div className="flex items-center justify-between p-3 border rounded-lg">
                  <div>
                    <p className="font-medium">Maintenance scheduled</p>
                    <p className="text-sm text-muted-foreground">Bus LTD-007 - Tomorrow 9:00 AM</p>
                  </div>
                  <Badge className="bg-yellow-600">Scheduled</Badge>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Security Tab */}
        <TabsContent value="security" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Security Settings</CardTitle>
              <CardDescription>Manage your account security and access controls</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="currentPassword">Current Password</Label>
                <div className="relative">
                  <Input
                    id="currentPassword"
                    type={showPassword ? "text" : "password"}
                    placeholder="Enter current password"
                  />
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                  </Button>
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="newPassword">New Password</Label>
                <Input id="newPassword" type="password" placeholder="Enter new password" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="confirmPassword">Confirm New Password</Label>
                <Input id="confirmPassword" type="password" placeholder="Confirm new password" />
              </div>
              <Button className="w-full">Update Password</Button>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Two-Factor Authentication</CardTitle>
              <CardDescription>Add an extra layer of security to your account</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">SMS Authentication</p>
                  <p className="text-sm text-muted-foreground">Receive codes via SMS</p>
                </div>
                <Switch />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Email Authentication</p>
                  <p className="text-sm text-muted-foreground">Receive codes via email</p>
                </div>
                <Switch defaultChecked />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Access Control</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <Button variant="outline" className="w-full justify-start bg-transparent">
                <Eye className="mr-2 h-4 w-4" />
                View Login History
              </Button>
              <Button variant="outline" className="w-full justify-start bg-transparent">
                <Download className="mr-2 h-4 w-4" />
                Download Security Report
              </Button>
              <Button variant="outline" className="w-full justify-start bg-transparent">
                <Shield className="mr-2 h-4 w-4" />
                Manage API Keys
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Notifications Tab */}
        <TabsContent value="notifications" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Notification Preferences</CardTitle>
              <CardDescription>Configure how you receive system alerts and updates</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Emergency Alerts</p>
                  <p className="text-sm text-muted-foreground">Critical system failures and emergencies</p>
                </div>
                <Switch
                  checked={notifications.emergencyAlerts}
                  onCheckedChange={(checked) => setNotifications((prev) => ({ ...prev, emergencyAlerts: checked }))}
                />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">System Updates</p>
                  <p className="text-sm text-muted-foreground">Software updates and maintenance notifications</p>
                </div>
                <Switch
                  checked={notifications.systemUpdates}
                  onCheckedChange={(checked) => setNotifications((prev) => ({ ...prev, systemUpdates: checked }))}
                />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Daily Reports</p>
                  <p className="text-sm text-muted-foreground">Daily operational summaries</p>
                </div>
                <Switch
                  checked={notifications.dailyReports}
                  onCheckedChange={(checked) => setNotifications((prev) => ({ ...prev, dailyReports: checked }))}
                />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Maintenance Alerts</p>
                  <p className="text-sm text-muted-foreground">Vehicle maintenance reminders</p>
                </div>
                <Switch
                  checked={notifications.maintenanceAlerts}
                  onCheckedChange={(checked) => setNotifications((prev) => ({ ...prev, maintenanceAlerts: checked }))}
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Recent Alerts</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="flex items-start gap-3 p-3 bg-red-50 border border-red-200 rounded-lg">
                  <AlertTriangle className="h-5 w-5 text-red-600 mt-0.5" />
                  <div>
                    <p className="font-medium text-red-800">Bus LTD-005 GPS Signal Lost</p>
                    <p className="text-sm text-red-600">Last known location: Binmaley - 15 minutes ago</p>
                  </div>
                </div>
                <div className="flex items-start gap-3 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
                  <Clock className="h-5 w-5 text-yellow-600 mt-0.5" />
                  <div>
                    <p className="font-medium text-yellow-800">Route Delay Alert</p>
                    <p className="text-sm text-yellow-600">Bus LTD-002 is 20 minutes behind schedule</p>
                  </div>
                </div>
                <div className="flex items-start gap-3 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                  <Bell className="h-5 w-5 text-blue-600 mt-0.5" />
                  <div>
                    <p className="font-medium text-blue-800">System Update Completed</p>
                    <p className="text-sm text-blue-600">Mobile app version 2.1.3 deployed successfully</p>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Settings Tab */}
        <TabsContent value="settings" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>System Configuration</CardTitle>
              <CardDescription>Advanced system settings and configurations</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <Button variant="outline" className="h-16 flex-col bg-transparent">
                  <Settings className="h-5 w-5 mb-1" />
                  System Settings
                </Button>
                <Button variant="outline" className="h-16 flex-col bg-transparent">
                  <Users className="h-5 w-5 mb-1" />
                  User Management
                </Button>
                <Button variant="outline" className="h-16 flex-col bg-transparent">
                  <BarChart3 className="h-5 w-5 mb-1" />
                  Analytics Config
                </Button>
                <Button variant="outline" className="h-16 flex-col bg-transparent">
                  <Shield className="h-5 w-5 mb-1" />
                  Security Policies
                </Button>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Emergency Controls</CardTitle>
              <CardDescription className="text-red-600">
                Use these controls only in emergency situations
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <Button variant="destructive" className="w-full">
                <AlertTriangle className="mr-2 h-4 w-4" />
                Emergency System Shutdown
              </Button>
              <Button variant="outline" className="w-full border-red-300 text-red-600 hover:bg-red-50 bg-transparent">
                Broadcast Emergency Alert
              </Button>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  )
}
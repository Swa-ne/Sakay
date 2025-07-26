// Profile Changes

"use client"

import { useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Switch } from "@/components/ui/switch"
import { Separator } from "@/components/ui/separator"
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@radix-ui/react-collapsible"
import { User, Settings, Bell, Shield, ChevronDown, ChevronRight, Edit, UserPlus, Terminal } from "lucide-react"

export default function AdminProfile() {
  const [activeSection, setActiveSection] = useState("account-preferences")
  const [isEditing, setIsEditing] = useState(false)
  const [settings, setSettings] = useState({
    realTimeSync: true,
    overrideUserControls: false,
    toggleNotifications: true,
  })
  const [expandedSections, setExpandedSections] = useState<string[]>([])

  const sidebarItems = [
    { id: "account-preferences", label: "Account Preferences", icon: User },
    { id: "system-settings", label: "System Settings", icon: Settings },
    { id: "notifications", label: "Notification Settings", icon: Bell },
    { id: "admin-management", label: "Admin Management", icon: UserPlus },
    { id: "terms-conditions", label: "Terms & Conditions", icon: Shield },
  ]

  const termsItems = [
    {
      id: "data-policy",
      title: "App's Data Policy",
      content:
        "Our app collects and processes data in accordance with applicable privacy laws and regulations. All data collected is used to improve service quality and user experience.",
    },
    {
      id: "license-responsibilities",
      title: "License Responsibilities",
      content:
        "Users are responsible for maintaining the confidentiality of their account credentials and for all activities that occur under their account.",
    },
    {
      id: "data-privacy",
      title: "Data Privacy",
      content:
        "We implement appropriate technical and organizational measures to protect personal data against unauthorized access, alteration, disclosure, or destruction.",
    },
    {
      id: "system-usage",
      title: "System Usage",
      content:
        "The system should be used in accordance with company policies and applicable laws. Misuse may result in account suspension or termination.",
    },
    {
      id: "real-time-updates",
      title: "Real-Time Updates & Web-Device Link",
      content:
        "Real-time synchronization ensures data consistency across all connected devices. Users should maintain stable internet connectivity for optimal performance.",
    },
    {
      id: "changes-modifications",
      title: "Changes and Modifications",
      content:
        "We reserve the right to modify these terms and conditions at any time. Users will be notified of significant changes through the application.",
    },
  ]

  const toggleExpanded = (sectionId: string) => {
    setExpandedSections((prev) =>
      prev.includes(sectionId) ? prev.filter((id) => id !== sectionId) : [...prev, sectionId],
    )
  }

  return (
    <div className="p-6 w-full max-w-7xl mx-auto">
      <div className="flex gap-6">
        {/* Left Navigation */}
        <div className="w-64 flex-shrink-0">
          <div className="sticky top-6 space-y-2">
            {sidebarItems.slice(0, -1).map((item) => {
              const Icon = item.icon
              return (
                <button
                  key={item.id}
                  onClick={() => setActiveSection(item.id)}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left transition-colors ${
                    activeSection === item.id
                      ? "bg-blue-50 text-blue-700 border border-blue-200"
                      : "text-gray-600 hover:bg-gray-50 border border-transparent"
                  }`}
                >
                  <Icon className="w-5 h-5" />
                  <span className="font-medium">{item.label}</span>
                </button>
              )
            })}
          </div>
        </div>

        {/* Main Content - Scrollable */}
        <div className="flex-1 min-h-screen">
          <div className="space-y-6">
            {/* Account Preferences */}
            {activeSection === "account-preferences" && (
              <>
                <div className="flex items-center justify-between mb-6">
                  <h1 className="text-2xl font-bold">Account Preferences</h1>
                  <Button
                    onClick={() => setIsEditing(!isEditing)}
                    variant={isEditing ? "outline" : "default"}
                    size="sm"
                  >
                    <Edit className="w-4 h-4 mr-2" />
                    {isEditing ? "Cancel" : "Edit"}
                  </Button>
                </div>

                <Card>
                  <CardContent className="p-6">
                    <div className="flex items-center gap-4 mb-6">
                      <div className="w-20 h-20 bg-gradient-to-br from-blue-500 to-blue-600 rounded-full flex items-center justify-center text-white text-2xl font-bold">
                        L
                      </div>
                      <div>
                        <h2 className="text-xl font-semibold">Libanok</h2>
                        <p className="text-gray-500">admin@ltdc.com.ph</p>
                      </div>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <Label htmlFor="name">Name</Label>
                        <Input id="name" defaultValue="Libanok" disabled={!isEditing} />
                      </div>
                      <div className="space-y-2">
                        <Label htmlFor="email">Email</Label>
                        <Input id="email" defaultValue="admin@ltdc.com.ph" disabled={!isEditing} />
                      </div>
                      <div className="space-y-2">
                        <Label htmlFor="contact">Contact</Label>
                        <Input id="contact" defaultValue="+63 912 345 6789" disabled={!isEditing} />
                      </div>
                    </div>

                    {isEditing && (
                      <div className="flex gap-2 mt-6">
                        <Button className="bg-green-600 hover:bg-green-700">Save Changes</Button>
                        <Button variant="outline" onClick={() => setIsEditing(false)}>
                          Cancel
                        </Button>
                      </div>
                    )}
                  </CardContent>
                </Card>

                {/* System Settings */}
                <Card>
                  <CardHeader>
                    <CardTitle>System Settings</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Enable Real-Time Sync for Admins</p>
                        <p className="text-sm text-gray-500">
                          Automatically sync admin actions across all connected devices and sessions
                        </p>
                      </div>
                      <Switch
                        checked={settings.realTimeSync}
                        onCheckedChange={(checked) => setSettings((prev) => ({ ...prev, realTimeSync: checked }))}
                      />
                    </div>
                    <Separator />
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Override User Controls</p>
                        <p className="text-sm text-gray-500">Allow admin to override user settings and preferences</p>
                      </div>
                      <Switch
                        checked={settings.overrideUserControls}
                        onCheckedChange={(checked) =>
                          setSettings((prev) => ({ ...prev, overrideUserControls: checked }))
                        }
                      />
                    </div>
                  </CardContent>
                </Card>

                {/* Notification Settings */}
                <Card>
                  <CardHeader>
                    <CardTitle>Notification Settings</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Toggle Notifications</p>
                        <p className="text-sm text-gray-500">Enable or disable system-wide notification alerts</p>
                      </div>
                      <Switch
                        checked={settings.toggleNotifications}
                        onCheckedChange={(checked) =>
                          setSettings((prev) => ({ ...prev, toggleNotifications: checked }))
                        }
                      />
                    </div>
                  </CardContent>
                </Card>

                {/* Admin Message Alert Settings */}
                <Card>
                  <CardHeader>
                    <CardTitle>Admin Message Alert Settings</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-sm text-gray-600 mb-4">
                      Configure how admin messages and alerts are delivered to users and other administrators.
                    </p>
                    <Button variant="outline" className="w-full bg-transparent">
                      Configure Alert Settings
                    </Button>
                  </CardContent>
                </Card>

                {/* Admin Management */}
                <Card>
                  <CardHeader>
                    <CardTitle>Admin Management</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-3">
                    <div className="flex items-center justify-between p-3 border rounded-lg">
                      <div className="flex items-center gap-3">
                        <UserPlus className="w-5 h-5 text-blue-600" />
                        <div>
                          <p className="font-medium">Add/Edit Admin Roles</p>
                          <p className="text-sm text-gray-500">Manage administrator permissions and access levels</p>
                        </div>
                      </div>
                      <Button variant="outline" size="sm">
                        Edit
                      </Button>
                    </div>
                    <div className="flex items-center justify-between p-3 border rounded-lg">
                      <div className="flex items-center gap-3">
                        <Terminal className="w-5 h-5 text-green-600" />
                        <div>
                          <p className="font-medium">Manage Terminal Settings</p>
                          <p className="text-sm text-gray-500">Configure terminal access and system controls</p>
                        </div>
                      </div>
                      <Button variant="outline" size="sm">
                        Edit
                      </Button>
                    </div>
                  </CardContent>
                </Card>

                {/* Terms & Conditions */}
                <Card>
                  <CardHeader>
                    <CardTitle>Terms & Conditions</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-2">
                    {termsItems.map((item) => (
                      <Collapsible key={item.id}>
                        <CollapsibleTrigger
                          className="flex items-center justify-between w-full p-3 text-left border rounded-lg hover:bg-gray-50"
                          onClick={() => toggleExpanded(item.id)}
                        >
                          <span className="font-medium">{item.title}</span>
                          {expandedSections.includes(item.id) ? (
                            <ChevronDown className="w-4 h-4" />
                          ) : (
                            <ChevronRight className="w-4 h-4" />
                          )}
                        </CollapsibleTrigger>
                        <CollapsibleContent className="px-3 py-2 text-sm text-gray-600 border-l-2 border-gray-200 ml-3 mt-2">
                          {item.content}
                        </CollapsibleContent>
                      </Collapsible>
                    ))}
                  </CardContent>
                </Card>
              </>
            )}

            {/* Other sections can be implemented similarly */}
            {activeSection === "notifications" && (
              <Card>
                <CardHeader>
                  <CardTitle>Notification Settings</CardTitle>
                  <CardDescription>Manage your notification preferences</CardDescription>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600">Notification settings will be configured here.</p>
                </CardContent>
              </Card>
            )}

            {activeSection === "account-management" && (
              <Card>
                <CardHeader>
                  <CardTitle>Account Management</CardTitle>
                  <CardDescription>Manage account settings and security</CardDescription>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600">Account management options will be available here.</p>
                </CardContent>
              </Card>
            )}

            {activeSection === "theme-appearance" && (
              <Card>
                <CardHeader>
                  <CardTitle>Theme & Appearance</CardTitle>
                  <CardDescription>Customize the look and feel of your interface</CardDescription>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600">Theme and appearance settings will be configured here.</p>
                </CardContent>
              </Card>
            )}

            {activeSection === "general-settings" && (
              <Card>
                <CardHeader>
                  <CardTitle>General Settings</CardTitle>
                  <CardDescription>Configure general application settings</CardDescription>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600">General settings will be available here.</p>
                </CardContent>
              </Card>
            )}

            {activeSection === "privacy-settings" && (
              <Card>
                <CardHeader>
                  <CardTitle>Privacy Settings</CardTitle>
                  <CardDescription>Manage your privacy and data settings</CardDescription>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600">Privacy settings will be configured here.</p>
                </CardContent>
              </Card>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

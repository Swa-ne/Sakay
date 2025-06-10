'use client';
import React, { useState } from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Bus, BusFront, LifeBuoy, Plus, ShieldUser, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { AccountTable } from '@/components/accountTable';
import { UnitsTable } from '@/components/unitTable';

interface StatisticsCard {
    title: string;
    count: number;
    icon: React.ReactNode;
    color: string;
}

type Role = 'driver' | 'commuter' | 'admin';

export interface Account {
    id: number;
    name: string;
    role: Role;
    assignedUnitId?: number;
}

export interface Unit {
    id: number;
    name: string;
    bus_number: string;
    plate_number: string;
    assignedDriverId: number;
}

const ManageAccount = () => {
    const [units, setUnits] = useState<Unit[]>([
        { id: 1, name: 'Unit ABC', bus_number: '402', plate_number: 'ABC 123', assignedDriverId: 1 },
        { id: 2, name: 'Unit XYZ', bus_number: '403', plate_number: 'ABC 124', assignedDriverId: 2 },
        { id: 3, name: 'Unit 123', bus_number: '404', plate_number: 'ABC 125', assignedDriverId: 3 },
    ]);

    const [accounts, setAccounts] = useState<Account[]>([
        { id: 1, name: 'John Doe', role: 'driver', assignedUnitId: 1 },
        { id: 2, name: 'Jane Smith', role: 'commuter' },
        { id: 3, name: 'Bob Admin', role: 'admin' },
    ]);

    const statisticsCards: StatisticsCard[] = [
        {
            title: 'Users',
            count: accounts.length,
            icon: <Users className='h-20 w-20' />,
            color: 'bg-sky-100 text-sky-600',
        },
        {
            title: 'Commuters',
            count: accounts.filter((a) => a.role === 'commuter').length,
            icon: <BusFront className='h-20 w-20' />,
            color: 'bg-yellow-100 text-yellow-600',
        },
        {
            title: 'Drivers',
            count: accounts.filter((a) => a.role === 'driver').length,
            icon: <LifeBuoy className='h-20 w-20' />,
            color: 'bg-rose-100 text-rose-600',
        },
        {
            title: 'Admin',
            count: accounts.filter((a) => a.role === 'admin').length,
            icon: <ShieldUser className='h-20 w-20' />,
            color: 'bg-indigo-100 text-indigo-600',
        },
        {
            title: 'Units',
            count: units.length,
            icon: <Bus className='h-20 w-20' />,
            color: 'bg-emerald-100 text-emerald-600',
        },
    ];

    const tabs = [{ name: 'Accounts' }, { name: 'Units' }];

    const [filterRole, setFilterRole] = useState<Role | 'all'>('all');

    const filteredAccounts = accounts.filter((acc) => (filterRole === 'all' ? true : acc.role === filterRole));

    const assignDriverToUnit = (accountId: number, unitId?: number) => {
        setAccounts((prev) => prev.map((acc) => (acc.id === accountId ? { ...acc, assignedUnitId: unitId } : acc)));
    };

    return (
        <div className='p-5 w-full h-screen flex space-x-5'>
            <div className='w-1/4 rounded-2xl p-5 overflow-y-auto space-y-6'>
                <div className='w-full flex justify-between items-center'>
                    <h2 className='text-2xl font-semibold mb-2'>Account & Units Overview</h2>
                </div>

                {statisticsCards.map((card, index) => (
                    <div key={index} className={`w-full p-4 rounded-xl shadow-sm hover:shadow-md transition-all duration-200 flex items-center space-x-4 ${card.color}`}>
                        <div className='p-3 rounded-full flex items-center justify-center'>{card.icon}</div>
                        <div className='flex-1'>
                            <p className='text-lg font-medium text-muted-foreground'>{card.title}</p>
                            <p className='text-3xl font-bold text-foreground'>{card.count}</p>
                        </div>
                    </div>
                ))}
            </div>

            <div className='w-3/4 h-full bg-background rounded-2xl overflow-hidden relative p-5 flex flex-col'>
                <Tabs defaultValue={tabs[0].name} className='w-full flex flex-col flex-grow'>
                    <TabsList className='p-0 bg-background justify-start border-b rounded-none space-x-2 mb-3'>
                        {tabs.map((tab) => (
                            <TabsTrigger key={tab.name} value={tab.name} className='rounded-none bg-background h-full data-[state=active]:shadow-none border-b-2 border-transparent data-[state=active]:border-b-primary'>
                                <code className='text-lg'>{tab.name}</code>
                            </TabsTrigger>
                        ))}
                    </TabsList>

                    <TabsContent value='Accounts' className='flex flex-col flex-grow overflow-y-auto'>
                        <div className='flex space-x-3 items-center justify-between mb-4 px-4 py-2'>
                            <div className=' flex space-x-3'>
                                {['all', 'driver', 'commuter', 'admin'].map((r) => (
                                    <Button key={r} onClick={() => setFilterRole(r as Role | 'all')} className={`px-4 py-5 rounded ${filterRole === r ? 'bg-primary text-white' : 'bg-gray-200'}`}>
                                        {r.charAt(0).toUpperCase() + r.slice(1)}
                                    </Button>
                                ))}
                            </div>

                            <Button className='text-background px-4 py-5'>
                                Add Driver <Plus />
                            </Button>
                        </div>

                        <AccountTable filteredAccounts={filteredAccounts} units={units} assignDriverToUnit={assignDriverToUnit} />
                    </TabsContent>

                    <TabsContent value='Units' className='overflow-y-auto'>
                        <div className='flex justify-between items-center mb-4'>
                            <h3 className='text-xl font-semibold mb-3'>Units List</h3>
                            <Button className='text-background px-4 py-5'>
                                Add Unit <Plus />
                            </Button>
                        </div>
                        <UnitsTable units={units} drivers={accounts} />
                    </TabsContent>
                </Tabs>
            </div>
        </div>
    );
};

export default ManageAccount;

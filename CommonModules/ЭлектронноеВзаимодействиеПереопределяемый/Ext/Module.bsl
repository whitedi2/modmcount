﻿
&После("ПриСозданииФормыПодсистемы")
Процедура УУ_ПриСозданииФормыПодсистемы(Контекст, Отказ, СтандартнаяОбработка)
	
	Если Контекст.Назначение = "СопоставлениеНоменклатуры" Тогда
		Если Контекст.Форма.Параметры.Свойство("СопоставлениеИзПриемкиМассивНоменклатуры") Тогда
			Если ТипЗнч(Контекст.Форма.Параметры.СопоставлениеИзПриемкиМассивНоменклатуры) = Тип("Массив") Тогда 
				//НовыйСписокВыбора = Новый СписокЗначений;
				//НовыйСписокВыбора.Очистить();..ЗагрузитьЗначения(Контекст.Форма.Параметры.СопоставлениеИзПриемкиМассивНоменклатуры);
				//Контекст.Форма.Элементы.СопоставлениеНоменклатура.СписокВыбора.Очистить();
				//Контекст.Форма.Элементы.СопоставлениеНоменклатура.СписокВыбора.ЗагрузитьЗначения(Контекст.Форма.Параметры.СопоставлениеИзПриемкиМассивНоменклатуры);
                Контекст.Форма.Элементы.СопоставлениеНоменклатура.КнопкаВыбора = Истина;
			Контекст.Форма.Элементы.СопоставлениеНоменклатура.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВВыпадающемСпискеИВПолеВвода;
				Контекст.Форма.Элементы.СопоставлениеНоменклатура.ВыборГруппИЭлементов = ГруппыИЭлементы.Элементы;   
				Контекст.Форма.Элементы.СопоставлениеНоменклатура.КнопкаВыпадающегоСписка = Ложь;
				//Контекст.Форма.Элементы.СопоставлениеНоменклатура.БыстрыйВыбор = Ложь;
				//Контекст.Форма.Элементы.СопоставлениеНоменклатура.РежимВыбораИзСписка = Ложь;
				Контекст.Форма.Элементы.СопоставлениеНоменклатура.ИсторияВыбораПриВводе = ИсторияВыбораПриВводе.НеИспользовать;

				Контекст.Форма.Элементы.СопоставлениеНоменклатура.ВыбиратьТип = Ложь;
				Для Каждого Стр Из Контекст.Форма.Объект.Сопоставление Цикл
					 Стр.Номенклатура = Справочники.Номенклатура.ПустаяСсылка();
				КонецЦикла;;
				Массив = Новый Массив(); 
				Массив.Добавить(Тип("СправочникСсылка.Номенклатура")); 
				НашеОписание = Новый ОписаниеТипов(Массив);

				Контекст.Форма.Элементы.СопоставлениеНоменклатура.ОграничениеТипа = НашеОписание; 
				//ПолеВвода1 = НашеОписание.ПривестиЗначение(ПолеВвода1); 
				Контекст.Форма.Элементы.Сопоставление.УстановитьДействие("ПриАктивизацииСтроки",""); 
				//Контекст.Форма.Элементы.Сопоставление.УстановитьДействие("ПриИзменении",""); 
			ФиксМассивНоменклатуры = Новый ФиксированныйМассив(Контекст.Форма.Параметры.СопоставлениеИзПриемкиМассивНоменклатуры);	
				МассивПараметровВыбора = Новый Массив;
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ФиксМассивНоменклатуры));
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.ЭтоГруппа", Ложь));  
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("СопоставлениеИзПриемкиВыборНоменклатурыБезГруппДляФормыСопоставления", Истина));
		НовыеПараметрыВыбора =  Новый ФиксированныйМассив(МассивПараметровВыбора);
		Контекст.Форма.Элементы.СопоставлениеНоменклатура.ПараметрыВыбора = НовыеПараметрыВыбора;


				Контекст.Форма.ОперацияПоискаВариантов = Неопределено;			
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
